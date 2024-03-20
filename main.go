// https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/golang-handler.html
// https://qiita.com/Imamotty/items/3fbe8ce6da4f1a653fae
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"

	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Key1 string `json:"key1"`
	Key2 string `json:"key2"`
	Key3 string `json:"key3"`
}

func HandleRequest(ctx context.Context, event *MyEvent) (*string, error) {
	if event == nil {
		return nil, fmt.Errorf("received nil event")
	}

	// JSON形式でエンコード
	eventBytes, err := json.Marshal(event)
	if err != nil {
		return nil, err
	}

	// slogを使ってログ出力
	slog.Info(string(eventBytes))
	message := "Hello from Lamda"
	return &message, nil
}

func main() {
	lambda.Start(HandleRequest)
}
