variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "BQ_DATASET" {
  type = string
}

variable "project_number" {
  type = number
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "cloud_composer_bucket" {
  type = string
}
