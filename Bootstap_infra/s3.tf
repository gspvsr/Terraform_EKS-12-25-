resource "aws_s3_bucket" "remote-state-backend32" {
  bucket = "remote-state-backend32"

  tags = {
    Name        = "Terraform_State_bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "remote-state-backend32_versioning" {
  bucket = aws_s3_bucket.remote-state-backend32.id

  versioning_configuration {
    status = "Enabled"
  }
}
