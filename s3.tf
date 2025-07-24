resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "devops-pipeline-artifacts-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

