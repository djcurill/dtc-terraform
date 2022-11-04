variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "project_number" {
  description = "Project number of GCP account"
  type        = number
}

variable "env" {
  description = "Environment, choose: dev or prod"
  type        = string
}

variable "region" {
  description = "Cloud region (i.e. us-east1)"
  type        = string
}

variable "vpc" {
  description = "VPC network id attribute"
  type = object({
    id = string
  })
}
