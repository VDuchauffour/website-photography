output "website_bucket_name" {
  description = "Website bucket name for s3 sync"
  value       = scaleway_object_bucket.website.name
}

output "website_endpoint" {
  description = "S3 website endpoint (direct, bypasses CDN)"
  value       = scaleway_object_bucket_website_configuration.website.website_endpoint
}

output "edge_services_pipeline_id" {
  description = "Edge Services pipeline ID — set as SCW_EDGE_PIPELINE_ID in GitHub Actions"
  value       = scaleway_edge_services_pipeline.website.id
}

output "edge_services_cname_target" {
  description = "CNAME target — point your domain DNS here"
  value       = scaleway_edge_services_dns_stage.website.default_fqdn
}
