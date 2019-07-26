/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


provider "google" {
  version = "~> 2.9.0"
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  version = "~> 2.9.0"
  project = var.project_id
  region  = var.region
}

locals {
  name = "beta-cluster-${random_string.suffix.result}"
}

resource "google_kms_key_ring" "this" {
  location = "global"
  name     = local.name
}

resource "google_kms_crypto_key" "this" {
  name     = local.name
  key_ring = google_kms_key_ring.this.self_link
}

module "this" {
  source = "../../../modules/beta-public-cluster"

  name              = local.name
  project_id        = var.project_id
  regional          = false
  region            = var.region
  zones             = slice(var.zones, 0, 1)
  network           = google_compute_network.main.name
  subnetwork        = google_compute_subnetwork.main.name
  ip_range_pods     = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  service_account   = "create"

  // Beta features
  istio                       = true
  database_encryption         = [{
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.this.self_link
  }]
  cloudrun                    = true
  enable_binary_authorization = true
  pod_security_policy_config  = true
  node_metadata               = "EXPOSE"
}

data "google_client_config" "default" {
}

