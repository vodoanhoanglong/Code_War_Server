package action

import (
	"context"
	"encoding/json"
)

const (
	actionUpdateDiscussReact = "discussReactUpdate"
)

type discuss_reacts_pk_columns_input map[string]interface{}
type discuss_reacts_insert_input map[string]interface{}
type discuss_reacts_bool_exp map[string]interface{}
type discuss_reacts_set_input map[string]interface{}

func updateDiscussReact(ctx *actionContext, payload []byte) (interface{}, error) {
	var appInput struct {
		Data struct {
			ID        string `json:"id"`
			DiscussId string `json:"discussId"`
		} `json:"data"`
	}

	if err := json.Unmarshal(payload, &appInput); err != nil {
		return nil, err
	}

	var query struct {
		DiscussReact []struct {
			ID     string `graphql:"id"`
			Status string `graphql:"status"`
		} `graphql:"discuss_reacts(where: $where, limit: 1)"`
	}

	variables := map[string]interface{}{
		"where": discuss_reacts_bool_exp{
			"_and": map[string]interface{}{
				"accountId": map[string]string{
					"_eq": ctx.Access.UserID,
				},
				"discussId": map[string]string{
					"_eq": appInput.Data.DiscussId,
				},
			},
		},
	}

	if err := ctx.Controller.Query(context.Background(), &query, variables); err != nil {
		return nil, err
	}

	if len(query.DiscussReact) == 0 {
		var mutationCreate struct {
			CreateDiscussReact struct {
				ID string `graphql:"id"`
			} `graphql:"insert_discuss_reacts_one(object: $object)"`
		}

		variables := map[string]interface{}{
			"object": discuss_reacts_insert_input{
				"accountId": ctx.Access.UserID,
				"createdBy": ctx.Access.UserID,
				"discussId": appInput.Data.DiscussId,
			},
		}

		if err := ctx.Controller.Mutate(context.Background(), &mutationCreate, variables); err != nil {
			return nil, err
		}

		return "create success", nil
	}

	var mutationUpdate struct {
		UpdateDiscussReact struct {
			ID string `graphql:"id"`
		} `graphql:"update_discuss_reacts_by_pk(pk_columns: $pk_columns, _set: $set)"`
	}

	status := "deleted"

	if query.DiscussReact[0].Status == "deleted" {
		status = "active"
	}

	discussReactId := appInput.Data.ID

	if discussReactId == "" {
		discussReactId = query.DiscussReact[0].ID
	}

	variablesUpdate := map[string]interface{}{
		"pk_columns": discuss_reacts_pk_columns_input{
			"id": discussReactId,
		},
		"set": discuss_reacts_set_input{
			"status": status,
		},
	}

	if err := ctx.Controller.Mutate(context.Background(), &mutationUpdate, variablesUpdate); err != nil {
		return nil, err
	}

	return "update success", nil
}
