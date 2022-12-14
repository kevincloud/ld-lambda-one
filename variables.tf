variable "aws_region" {
  description = "The AWS region this application will run in"
  default     = "us-west-2"
}

variable "ld_sdk_key" {
  description = "Your LD SDK key"
}

variable "ld_access_token" {
  description = "Your LD API token"
}

variable "ld_project_key" {
  description = "Your LD project key (i.e. my-cool-project)"
}

variable "unique_identifier" {
  description = "A unique identifier for naming resources to avoid name collisions"
  validation {
    condition     = can(regex("^[a-z]{6,10}$", var.unique_identifier))
    error_message = "unique_identifier must be lower case letters only and 6 to 10 characters in length"
  }
}

variable "owner" {
  description = "Your email address"
}
