############################
# Scaleway credentials
############################

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
  description = "Scaleway IAM user ID (owner of API keys)"
  type        = string
}

############################
# Bucket configuration
############################

variable "region" {
  description = "Scaleway region (fr-par, nl-ams, pl-waw)"
  type        = string
  default     = "fr-par"
}

variable "bucket_name" {
  description = "Object Storage bucket name (globally unique)"
  type        = string
  default     = "photos"
}

variable "environment" {
  description = "Environment tag (production, staging)"
  type        = string
  default     = "production"
}

variable "cors_allowed_origins" {
  description = "Origins allowed to load images (your Hugo site domains)"
  type        = list(string)
  default     = ["*"]
}
