resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_website" {
  bucket = "static-content-terraform-${random_id.bucket_suffix.hex}"
}