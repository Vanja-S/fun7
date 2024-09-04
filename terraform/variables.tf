variable "gcp_credentials" {
  description = "GCP credentials injected via CI/CD in base64 format."
  type        = string
  sensitive   = true
}
