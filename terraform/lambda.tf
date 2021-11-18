resource "aws_lambda_function" "instance" {
  function_name = "lambda-function"
  filename      = "${path.module}/dummy-lambda-package/lambda.zip" // Simple hello world application
  role          = aws_iam_role.instance.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  vpc_config {
    security_group_ids = [aws_security_group.lambda_security_group.id]
    subnet_ids         = [aws_subnet.private.id]
  }

  environment {
    variables = {
      REDIS_HOST = aws_elasticache_cluster.instance.cache_nodes[0].address
      REDIS_PORT = aws_elasticache_cluster.instance.port
    }
  }
}
