output "bucket_name" {
  description = "Object Storage bucket name"
  value       = scaleway_object_bucket.photos.name
}

output "bucket_endpoint" {
  description = "S3 API endpoint for the bucket"
  value       = scaleway_object_bucket.photos.endpoint
}

output "base_url" {
  description = "Public URL prefix for images — use in Hugo frontmatter"
  value       = "https://${scaleway_object_bucket.photos.name}.s3.${var.region}.scw.cloud"
}
