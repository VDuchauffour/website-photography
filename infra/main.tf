############################
# Photo storage bucket
############################

resource "scaleway_object_bucket" "photos" {
  name          = var.bucket_name
  region        = var.region
  force_destroy = false

  cors_rule {
    allowed_origins = var.cors_allowed_origins
    allowed_methods = ["GET", "HEAD"]
    allowed_headers = ["*"]
    max_age_seconds = 86400
  }

  tags = {
    project     = "website-photography"
    environment = var.environment
    managed_by  = "terraform"
  }

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "abort-incomplete-uploads"
    enabled = true

    abort_incomplete_multipart_upload_days = 7
  }
}

############################
# Public read policy (Scaleway requires version 2023-04-17)
############################

resource "scaleway_object_bucket_policy" "photos_public_read" {
  bucket = scaleway_object_bucket.photos.id

  policy = jsonencode({
    Version = "2023-04-17"
    Id      = "PublicReadPolicy"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${scaleway_object_bucket.photos.name}/*"]
      }
    ]
  })
}
