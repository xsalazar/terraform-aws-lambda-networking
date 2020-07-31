resource "aws_lambda_function" instance {
  filename         = "${path.module}/files/lambda.zip"
  function_name    = "lambda-function"
  role             = aws_iam_role.instance.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.instance.output_base64sha256
  runtime          = "nodejs12.x"
  tags             = local.default_tags

  vpc_config {
    security_group_ids = [aws_security_group.instance.id]
    subnet_ids         = [aws_subnet.private.id]
  }

  environment {
    variables = {
      REDIS_HOST    = aws_elasticache_cluster.instance.cache_nodes[0].address
      REDIS_PORT    = aws_elasticache_cluster.instance.port
      GIPHY_API_KEY = var.giphy_api_key
    }
  }
}