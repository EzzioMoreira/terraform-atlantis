resource "aws_s3_bucket" "this" {
  for_each = local.environment[terraform.workspace].buckets
  bucket = each.value.bucket_name
  acl    = "private"
  tags   = local.tags

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each                = local.environment[terraform.workspace].buckets
  bucket                  = aws_s3_bucket.this[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
