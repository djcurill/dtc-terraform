variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "BQ_DATASET" {
  type = string
}
