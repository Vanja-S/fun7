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
}

resource "google_cloud_run_v2_service" "cts_north_america" {
  name     = "cts_north_america-service"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
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
      image = "us-docker.pkg.dev/cloudrun/container/hello"
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
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      ports {
        container_port = 8000
      }
    }
  }
}
