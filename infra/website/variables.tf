variable "scw_access_key" {
  description = "Scaleway API access key"
  type        = string
  sensitive   = true
}

variable "scw_secret_key" {
  description = "Scaleway API secret key"
  type        = string
  sensitive   = true
}

variable "scw_project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "scw_user_id" {
  description = "Scaleway IAM user ID (bucket policy owner)"
  type        = string
}

variable "region" {
  description = "Scaleway region (fr-par, nl-ams, pl-waw)"
  type        = string
  default     = "fr-par"
}

variable "environment" {
  description = "Environment tag (production, staging)"
  type        = string
  default     = "production"
}

variable "website_bucket_name" {
  description = "Object Storage bucket name for the Hugo static site"
  type        = string
  default     = "site-vincentduchauffour"
}

variable "website_domain" {
  description = "Root domain name managed in Scaleway Domains & DNS"
  type        = string
  default     = "vincentduchauffour.com"
}
