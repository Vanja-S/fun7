terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "random" {
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

resource "random_uuid" "revision_uuid" {}

resource "google_cloud_run_v2_service" "cts_north_america" {
  name     = "cts-north-america-service"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"


  template {
    revision = random_uuid.revision_uuid.result
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "cts_north_america_invoker" {
  location = google_cloud_run_v2_service.cts_north_america.location
  project  = google_cloud_run_v2_service.cts_north_america.project
  service  = google_cloud_run_v2_service.cts_north_america.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

resource "google_cloud_run_v2_service" "cts_asia" {
  name     = "cts-asia-service"
  location = "asia-east1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    revision = random_uuid.revision_uuid.result
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "cts_asia_invoker" {
  location = google_cloud_run_v2_service.cts_asia.location
  project  = google_cloud_run_v2_service.cts_asia.project
  service  = google_cloud_run_v2_service.cts_asia.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

resource "google_cloud_run_v2_service" "cts_europe" {
  name     = "cts-europe-service"
  location = "europe-central2"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    revision = random_uuid.revision_uuid.result
    containers {
      image = "europe-central2-docker.pkg.dev/compact-marker-434520-k0/fun7-cts-registry/fun7-cts:latest"
      ports {
        container_port = 8000
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "cts_europe_invoker" {
  location = google_cloud_run_v2_service.cts_europe.location
  project  = google_cloud_run_v2_service.cts_europe.project
  service  = google_cloud_run_v2_service.cts_europe.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}
