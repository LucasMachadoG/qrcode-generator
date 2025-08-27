resource "aws_s3_bucket" "qrcode_bucket" {
  bucket = var.bucket_name

  tags = {
    IAC = true
  }
}

resource "aws_s3_bucket_ownership_controls" "qrcode_bucket" {
  bucket = aws_s3_bucket.qrcode_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "qrcode_bucket" {
  bucket                  = aws_s3_bucket.qrcode_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "qrcode_bucket" {
  bucket = aws_s3_bucket.qrcode_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "qrcode_bucket" {
  bucket = aws_s3_bucket.qrcode_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_cors_configuration" "qrcode_bucket" {
  bucket = aws_s3_bucket.qrcode_bucket.id

  cors_rule {
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    max_age_seconds = 3600
  }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "AllowPublicRead"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.qrcode_bucket.arn}/qr/*"]
  }
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.qrcode_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}
