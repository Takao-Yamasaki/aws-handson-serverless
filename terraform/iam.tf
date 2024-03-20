# LamdaのIAMロールを作成
resource "aws_iam_role" "aws_handson_serverless_lamda" {
  name = "aws_handson_serverless_lamda"
  
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

# Lamda用のIAMポリシーを作成
# NOTE: CloudWatchのアクションを許可
resource "aws_iam_role_policy" "aws_handson_serverless_lamda" {
  name = "aws_handson_serverless_lamda"
  role = aws_iam_role.aws_handson_serverless_lamda.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  }
  EOF
}

// TranslateFullAccessをアタッチ
resource "aws_iam_role_policy_attachment" "aws_handson_serverless_lamda" {
  role = aws_iam_role.aws_handson_serverless_lamda.name
  policy_arn =  "arn:aws:iam::aws:policy/TranslateFullAccess"
}
