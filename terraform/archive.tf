data "archive_file" instance {
  type        = "zip"
  output_path = "${path.module}/files/lambda.zip"
  source_dir  = "../app"
}