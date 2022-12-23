terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "archive" {}

provider "launchdarkly" {
  access_token = var.ld_access_token
}
