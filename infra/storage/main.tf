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
# IAM — S3 upload credentials
############################

resource "scaleway_iam_policy" "user_s3_access" {
  name    = "photography-user-s3-access"
  user_id = var.scw_user_id

  rule {
    project_ids          = [var.scw_project_id]
    permission_set_names = ["ObjectStorageFullAccess"]
  }
}

resource "scaleway_iam_application" "upload" {
  name        = "photo-upload"
  description = "S3 upload access for photography portfolio"
}

resource "scaleway_iam_policy" "upload" {
  name           = "photo-upload-s3-access"
  application_id = scaleway_iam_application.upload.id

  rule {
    project_ids          = [var.scw_project_id]
    permission_set_names = ["ObjectStorageFullAccess"]
  }
}

resource "scaleway_iam_api_key" "upload" {
  application_id     = scaleway_iam_application.upload.id
  description        = "s3cmd upload key for photography bucket"
  default_project_id = var.scw_project_id
}

############################
# Public read policy (Scaleway requires version 2023-04-17)
############################

resource "scaleway_object_bucket_policy" "photos_public_read" {
  bucket = scaleway_object_bucket.photos.id

  policy = jsonencode({
    Version = "2023-04-17"
    Id      = "PhotosBucketPolicy"
    Statement = [
      {
        Sid       = "OwnerFullAccess"
        Effect    = "Allow"
        Principal = { SCW = "user_id:${var.scw_user_id}" }
        Action    = "s3:*"
        Resource = [
          scaleway_object_bucket.photos.name,
          "${scaleway_object_bucket.photos.name}/*"
        ]
      },
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
