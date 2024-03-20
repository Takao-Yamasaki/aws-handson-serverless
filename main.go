// https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/golang-handler.html
// https://qiita.com/Imamotty/items/3fbe8ce6da4f1a653fae
package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/translate"
)

func LamdaHandler(ctx context.Context) (*string, error) {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		return nil, fmt.Errorf("error loading AWS SDK config: %e", err)
	}

	client := translate.NewFromConfig(cfg)

	inputText := "おはよう"

	JA := "ja"
	EN := "en"

	// リクエストを作成
	request := translate.TranslateTextInput{
		SourceLanguageCode: &JA,
		TargetLanguageCode: &EN,
		Text:               &inputText,
	}

	// レスポンスを格納
	response, err := client.TranslateText(context.Background(), &request)
	if err != nil {
		return nil, fmt.Errorf("error translating text: %e", err)
	}

	// 翻訳結果を格納
	outputText := response.TranslatedText

	return outputText, nil
}

func main() {
	lambda.Start(LamdaHandler)
}
