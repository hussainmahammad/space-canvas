/* ================= UPLOAD FUNCTION ================= */

resource "aws_lambda_function" "upload" {
  function_name = "${local.prefix}-upload"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"

  filename         = "../../app/functions/upload.zip"
  source_code_hash = filebase64sha256("../../app/functions/upload.zip")

  timeout      = 60
  memory_size  = 256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.files.bucket
    }
  }
}


/* ================= PROCESS FUNCTION ================= */

resource "aws_lambda_function" "process" {
  function_name = "${local.prefix}-process"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"

  filename         = "../../app/functions/process.zip"
  source_code_hash = filebase64sha256("../../app/functions/process.zip")

  layers = [
    aws_lambda_layer_version.pdf_layer.arn
  ]

  # 🔥 FINAL FIX
  timeout      = 60
  memory_size  = 512

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.files.bucket
    }
  }
}
