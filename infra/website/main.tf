############################
# Website hosting bucket
############################

resource "scaleway_object_bucket" "website" {
  name   = var.website_bucket_name
  region = var.region

  tags = {
    project     = "website-photography"
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "scaleway_object_bucket_website_configuration" "website" {
  bucket = scaleway_object_bucket.website.name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "scaleway_object_bucket_policy" "website_public_read" {
  bucket = scaleway_object_bucket.website.id

  policy = jsonencode({
    Version = "2023-04-17"
    Id      = "WebsiteBucketPolicy"
    Statement = [
      {
        Sid       = "OwnerFullAccess"
        Effect    = "Allow"
        Principal = { SCW = "user_id:${var.scw_user_id}" }
        Action    = "s3:*"
        Resource = [
          scaleway_object_bucket.website.name,
          "${scaleway_object_bucket.website.name}/*"
        ]
      },
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${scaleway_object_bucket.website.name}/*"]
      }
    ]
  })
}

############################
# Edge Services CDN
############################

resource "scaleway_edge_services_plan" "main" {
  name = "starter"
}

resource "scaleway_edge_services_pipeline" "website" {
  name        = "photography-portfolio"
  description = "CDN pipeline for Hugo photography portfolio"
  depends_on  = [scaleway_edge_services_plan.main]
}

resource "scaleway_edge_services_backend_stage" "website" {
  pipeline_id = scaleway_edge_services_pipeline.website.id

  s3_backend_config {
    bucket_name   = scaleway_object_bucket.website.name
    bucket_region = var.region
    is_website    = true
  }
}

resource "scaleway_edge_services_cache_stage" "website" {
  pipeline_id      = scaleway_edge_services_pipeline.website.id
  backend_stage_id = scaleway_edge_services_backend_stage.website.id
  fallback_ttl     = 3600
}

resource "scaleway_edge_services_tls_stage" "website" {
  pipeline_id         = scaleway_edge_services_pipeline.website.id
  cache_stage_id      = scaleway_edge_services_cache_stage.website.id
  managed_certificate = true
}

resource "scaleway_edge_services_dns_stage" "website" {
  pipeline_id  = scaleway_edge_services_pipeline.website.id
  tls_stage_id = scaleway_edge_services_tls_stage.website.id
  fqdns        = [var.website_domain, "www.${var.website_domain}"]
}

resource "scaleway_edge_services_head_stage" "website" {
  pipeline_id   = scaleway_edge_services_pipeline.website.id
  head_stage_id = scaleway_edge_services_dns_stage.website.id
}

############################
# DNS records
############################

resource "scaleway_domain_record" "apex" {
  dns_zone = var.website_domain
  name     = ""
  type     = "ALIAS"
  data     = "${scaleway_edge_services_pipeline.website.id}.svc.edge.scw.cloud."
  ttl      = 300
}

resource "scaleway_domain_record" "www" {
  dns_zone = var.website_domain
  name     = "www"
  type     = "CNAME"
  data     = "${scaleway_edge_services_pipeline.website.id}.svc.edge.scw.cloud."
  ttl      = 300
}
