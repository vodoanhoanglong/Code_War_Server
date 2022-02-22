package action

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/google/uuid"
	"github.com/hasura/go-graphql-client"
	"nexlab.tech/core/pkg/util"
)

const (
	actionUploadFile = "uploadFile"
	actionMoveFile   = "moveFile"
)

type files_insert_input map[string]interface{}
type files_bool_exp map[string]interface{}
type move_file_args map[string]interface{}
type UploadFileInput struct {
	Name      string `json:"name"`
	Path      string `json:"path"`
	Size      int    `json:"size"`
	Url       string `json:"url"`
	Extension string `json:"extension"`
}

type MoveFileInput struct {
	ToPath        string `json:"to_path"`
	ToExtension   string `json:"to_extension"`
	FromPath      string `json:"from_path"`
	FromExtension string `json:"from_extension"`
	FromName      string `json:"from_name"`
}

func uploadFile(ctx *actionContext, payload []byte) (interface{}, error) {
	var appInput struct {
		Data UploadFileInput `json:"data"`
	}

	err := json.Unmarshal([]byte(payload), &appInput)
	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	input := appInput.Data
	if ok, _ := checkFileName(ctx, input.Path, input.Name, input.Extension); ok {
		return nil, errors.New("filename already exists")
	}

	randomUUID := uuid.New().String()
	path := input.Path + "/" + randomUUID

	var query struct {
		UploadFile struct {
			ID   string `graphql:"id"`
			Name string `graphql:"name"`
			Path string `graphql:"path"`
			Url  string `graphql:"url"`
		} `graphql:"insert_files_one(object: $object)"`
	}

	variables := map[string]interface{}{
		"object": files_insert_input{
			"id":        randomUUID,
			"name":      input.Name,
			"path":      path,
			"url":       input.Url,
			"size":      input.Size,
			"extension": input.Extension,
			"userId":    ctx.Access.UserID,
		},
	}

	err = ctx.Controller.Mutate(context.Background(), &query, variables)

	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	results := query.UploadFile

	return map[string]string{
		"id":   results.ID,
		"name": results.Name,
		"path": results.Path,
		"url":  results.Url,
	}, nil
}

func moveFile(ctx *actionContext, payload []byte) (interface{}, error) {
	var appInput struct {
		Data MoveFileInput `json:"data"`
	}

	err := json.Unmarshal([]byte(payload), &appInput)
	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	input := appInput.Data

	if input.ToExtension != "folder" {
		return nil, errors.New("destination path must be a directory")
	}

	if ok, _ := checkFileName(ctx, input.ToPath, input.FromName, input.FromExtension); ok {
		return nil, errors.New("filename already exists")
	}

	var query struct {
		MoveFile []struct {
			ID   string `graphql:"id"`
			Name string `graphql:"name"`
			Path string `graphql:"path"`
			Url  string `graphql:"url"`
		} `graphql:"move_file(args: $args)"`
	}

	variables := map[string]interface{}{
		"args": move_file_args{
			"from_path": input.FromPath,
			"to_path":   input.ToPath,
		},
	}

	err = ctx.Controller.Mutate(context.Background(), &query, variables)

	if err != nil {
		return nil, util.ErrBadRequest(err)
	}

	return map[string]string{
		"message": "success",
	}, nil
}

func checkFileName(ctx *actionContext, path string, name string, extension string) (bool, error) {
	var query struct {
		Files []struct {
			Name string `graphql:"name"`
		} `graphql:"files(where: $where, limit: 1)"`
	}

	variables := map[string]interface{}{
		"where": files_bool_exp{
			"_and": map[string]interface{}{
				"path": map[string]interface{}{
					"_similar": path + "/%",
				},
				"name": map[string]interface{}{
					"_eq": name,
				},
				"extension": map[string]interface{}{
					"_eq": extension,
				},
			},
		},
	}

	err := ctx.Controller.Query(context.Background(), &query, variables, graphql.OperationName("CheckFileName"))

	if err != nil {
		return true, err
	}

	if len(query.Files) > 0 {
		return true, nil
	}

	return false, nil
}
