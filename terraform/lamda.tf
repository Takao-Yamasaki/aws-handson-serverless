// main.goをローカルでビルドする
// https://engineering.nifty.co.jp/blog/20337
resource "null_resource" "default" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "cd ../lamda/cmd/ && GOOS=linux GOARCH=amd64 go build -o ../build/bootstrap ../../main.go"
  }
}

//  ビルドしたファイルをzip化
data "archive_file" "aws_handson_serverless_lamda" {
  type = "zip"
  source_file = "../lamda/build/bootstrap"
  output_path = "../lamda/archive/aws_handson_serverless_lamda.zip"

  // ビルド後にzip化する
  depends_on = [ null_resource.default ]
}

// Lamda Function
// https://docs.aws.amazon.com/lambda/latest/api/API_CreateFunction.html#SSS-CreateFunction-request-Runtime
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "aws_handson_serverless_lamda" {
  function_name = "translate-function"
  filename = data.archive_file.aws_handson_serverless_lamda.output_path
  source_code_hash = data.archive_file.aws_handson_serverless_lamda.output_base64sha256
  // NOTE: Amazon Linux2ベースのカスタムランタイムを使用
  runtime = "provided.al2"
  handler = "hello"
  role = aws_iam_role.aws_handson_serverless_lamda.arn
  // メモリを256MB
  memory_size = 256
  // タイムアウトを10秒
  timeout = 10
}
