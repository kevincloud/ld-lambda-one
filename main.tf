locals {
  dbvalues_fname         = "${var.unique_identifier}_lambda_dbvalues"
  dbvalues_loggroup      = "/aws/lambda/${local.dbvalues_fname}"
  incrementer_fname      = "${var.unique_identifier}_lambda_incrementer"
  incrementer_loggroup   = "/aws/lambda/${local.incrementer_fname}"
  incrementdb_fname      = "${var.unique_identifier}_lambda_incrementdb"
  incrementdb_loggroup   = "/aws/lambda/${local.incrementdb_fname}"
  incrementnone_fname    = "${var.unique_identifier}_lambda_incrementnone"
  incrementnone_loggroup = "/aws/lambda/${local.incrementnone_fname}"
}

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
