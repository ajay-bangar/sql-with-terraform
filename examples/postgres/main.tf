/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "region" {
  default = "us-central1"
}

variable "network" {
  default = "default"
}

variable "zone" {
  default = "us-central1-b"
}

variable "postgresql_version" {
  default = "POSTGRES_9_6"
}

provider "google" {
  region = "${var.region}"
}

data "google_client_config" "current" {}

resource "random_id" "name" {
  byte_length = 2
}

module "postgresql-db" {
  source           = "../../"
  name             = "example-postgresql-${random_id.name.hex}"
  user_host        = ""
  database_version = "${var.postgresql_version}"
}

output "psql_conn" {
  value = "${data.google_client_config.current.project}:${var.region}:${module.postgresql-db.instance_name}"
}

output "psql_user_pass" {
  value = "${module.postgresql-db.generated_user_password}"
}

