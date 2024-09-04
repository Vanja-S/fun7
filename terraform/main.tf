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

resource "google_cloud_run_v2_service" "cts_north_america" {
  name     = "cts_north_america-service"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}

resource "google_cloud_run_v2_service" "cts_asia" {
  name     = "cts_asia-service"
  location = "asia-east1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}

resource "google_cloud_run_v2_service" "cts_europe" {
  name     = "cts_europe-service"
  location = "europe-central2"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}
