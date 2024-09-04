terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.0.1"
    }
  }
}

provider "google" {
  project     = "compact-marker-434520-k0"
  credentials = base64decode(var.gcp_credentials)
  region      = "europe-central2"
}

resource "google_storage_bucket" "fun7_cts_terraform_state" {
  name          = "fun7_cts_terraform_state"
  location      = "europe-central2"
  force_destroy = true
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

