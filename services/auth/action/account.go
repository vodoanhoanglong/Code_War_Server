package action

import (
	"context"
	"encoding/json"

	"github.com/google/uuid"
	"nexlab.tech/core/pkg/util"
)

const (
	actionCreateAccount = "createAccount"
)

type account_bool_exp map[string]interface{}
type account_insert_input map[string]interface{}
type account_set_input map[string]interface{}
type account_pk_columns_input map[string]interface{}

type CreateAccountInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Role     string `json:"role"`
	FullName string `json:"full_name"`
}

// createAccount create or assign user to specific app
func createAccount(ctx *actionContext, payload []byte) (interface{}, error) {

	var appInput struct {
		Data CreateAccountInput `json:"data"`
	}

	err := json.Unmarshal([]byte(payload), &appInput)
	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	passwordHashed, err := ctx.JwtAuth.EncryptPassword(appInput.Data.Password)
	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	randomUUID := uuid.New().String()
	randomHashed, err := ctx.JwtAuth.EncryptPassword(randomUUID)

	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	var query struct {
		CreateAccount struct {
			ID       string `graphql:"id"`
			Email    string `graphql:"email"`
			FullName string `graphql:"fullName"`
			Role     string `graphql:"role"`
		} `graphql:"insert_account_one(object: $object)"`
	}

	variables := map[string]interface{}{
		"object": account_insert_input{
			"fullName":    appInput.Data.FullName,
			"email":       appInput.Data.Email,
			"password":    string(passwordHashed),
			"role":        appInput.Data.Role,
			"hashedToken": randomHashed,
		},
	}

	err = ctx.Controller.Mutate(context.Background(), &query, variables)

	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	return map[string]string{
		"id":        query.CreateAccount.ID,
		"email":     query.CreateAccount.Email,
		"full_name": query.CreateAccount.FullName,
	}, nil
}
