package action

import (
	"context"
	"encoding/json"
	"time"

	"nexlab.tech/core/pkg/util"
)

const (
	actionSaveResultExercise = "resultExercise"
)

type exercise_results_bool_exp map[string]interface{}
type exercise_results_pk_columns_input map[string]interface{}
type exercise_results_set_input map[string]interface{}
type exercise_results_insert_input map[string]interface{}

type ResultExerciseInput struct {
	ExerciseID string      `json:"exerciseId"`
	ExcuteTime float32     `json:"excuteTime"`
	Memory     int         `json:"memory"`
	Point      float32     `json:"point"`
	CaseFailed interface{} `jsonb:"caseFailed"`
}

func saveResultExercise(ctx *actionContext, payload []byte) (interface{}, error) {
	var appInput struct {
		Data ResultExerciseInput `json:"data"`
	}

	err := json.Unmarshal([]byte(payload), &appInput)
	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	// check exercise result exist
	var query struct {
		ExerciseResult []struct {
			ID string `graphql:"id"`
		} `graphql:"exercise_results(where: $where, limit: 1)"`
	}

	variables := map[string]interface{}{
		"where": exercise_results_bool_exp{
			"_and": map[string]interface{}{
				"exerciseId": map[string]string{
					"_eq": appInput.Data.ExerciseID,
				},
				"accountId": map[string]string{
					"_eq": ctx.Access.UserID,
				},
			},
		},
	}

	err = ctx.Controller.Query(context.Background(), &query, variables)

	if err != nil {
		return nil, err
	}

	if len(query.ExerciseResult) > 0 {

		var mutation struct {
			ExerciseResult struct {
				ID string `graphql:"id"`
			} `graphql:"update_exercise_results_by_pk(pk_columns: $pk_columns, _set: $set)"`
		}

		variables := map[string]interface{}{
			"pk_columns": exercise_results_pk_columns_input{
				"id": query.ExerciseResult[0].ID,
			},
			"set": exercise_results_set_input{
				"excuteTime": appInput.Data.ExcuteTime,
				"memory":     appInput.Data.Memory,
				"point":      appInput.Data.Point,
				"caseFailed": appInput.Data.CaseFailed,
				"updatedAt":  time.Now(),
			},
		}

		err = ctx.Controller.Mutate(context.Background(), &mutation, variables)

		if err != nil {
			return nil, err
		}

		return "update success", nil
	}

	var mutationCreate struct {
		ExerciseResult struct {
			ID string `graphql:"id"`
		} `graphql:"insert_exercise_results_one(object: $object)"`
	}

	variablesCreate := map[string]interface{}{
		"object": exercise_results_insert_input{
			"exerciseId": appInput.Data.ExerciseID,
			"accountId":  ctx.Access.UserID,
			"createdBy":  ctx.Access.UserID,
			"excuteTime": appInput.Data.ExcuteTime,
			"memory":     appInput.Data.Memory,
			"point":      appInput.Data.Point,
			"caseFailed": appInput.Data.CaseFailed,
		},
	}

	err = ctx.Controller.Mutate(context.Background(), &mutationCreate, variablesCreate)
	if err != nil {
		return nil, err
	}

	return "create success", err
}
