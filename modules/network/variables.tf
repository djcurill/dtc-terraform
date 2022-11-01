variable "project_id" {
    description = "GCP project id"
    type = string
}

variable "region" {
  description = "Compute region"
  type        = string
}

variable "env" {
  description = "Environment (i.e. dev, staging or prod)"
  type        = string
}
