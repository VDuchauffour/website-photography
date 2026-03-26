output "website_bucket_name" {
  description = "Website bucket name for s3 sync"
  value       = scaleway_object_bucket.website.name
}

output "website_endpoint" {
  description = "S3 website endpoint (direct, bypasses CDN)"
  value       = scaleway_object_bucket_website_configuration.website.website_endpoint
}
