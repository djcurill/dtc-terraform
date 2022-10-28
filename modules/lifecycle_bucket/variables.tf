variable "bucket_name" {
  description = "Name of gcp bucket"
  type        = string
}

variable "region" {
  description = "region of resource"
  type        = string
}

variable "max_age" {
  description = "Maximum number of days an object lives for"
  type        = number
  default     = 30 // days
}

variable "storage_class" {
  description = "Choose: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}