resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "${formatdate("YYYY-MM-DD-HH-MM", timestamp())}-${random_string.bucket_suffix.result}"
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.tf-state-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "object" {
  count  = var.create_resource ? 1 : 0
  key    = "terraform.tfstate"
  bucket = aws_s3_bucket.tf-state-bucket.id
  source = "./terraform.tfstate"
}
