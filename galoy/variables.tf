variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "terraform"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "galoy-test"
}