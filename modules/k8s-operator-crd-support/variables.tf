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

variable "cluster_name" {
  description = "The unique name to identify the cluster in ACM."
  type        = string
}

variable "project_id" {
  description = "The project in which the resource belongs."
  type        = string
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in."
  type        = string
}

## TODO(stevenlinde) would prefer local_manifest_path, if changeable a this point 
variable "operator_path" {
  description = "Path to the operator yaml config. If unset, will download from `var.operator_latest_manifest_url`."
  type        = string
  default     = null
}

variable "operator_latest_manifest_url" {
  description = "Url to the latest downloadable manifest for the operator. To be supplied by operator module providers, not end users."
  type        = string
}

variable "sync_repo" {
  description = "ACM Git repo address"
  type        = string
}

variable "sync_branch" {
  description = "ACM repo Git branch"
  type        = string
  default     = "master"
}

variable "policy_dir" {
  description = "Subfolder containing configs in ACM Git repo"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint."
  type        = string
}

variable "create_ssh_key" {
  description = "Controls whether a key will be generated for Git authentication"
  type        = bool
  default     = true
}

variable "ssh_auth_key" {
  description = "Key for Git authentication. Overrides 'create_ssh_key' variable. Can be set using 'file(path/to/file)'-function."
  type        = string
  default     = null
}

variable "enable_policy_controller" {
  description = "Whether to enable the ACM Policy Controller on the cluster"
  type        = bool
  default     = false
}

variable "install_template_library" {
  description = "Whether to install the default Policy Controller template library"
  type        = bool
  default     = false
}

variable "operator_template_path" {
  description = "path to template file to use for the operator"
  type        = string
}
