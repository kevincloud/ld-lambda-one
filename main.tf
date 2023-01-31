locals {
  dbvalues_fname          = "${var.unique_identifier}_lambda_dbvalues"
  dbvalues_loggroup       = "/aws/lambda/${local.dbvalues_fname}"
  incrementer_fname       = "${var.unique_identifier}_lambda_incrementer"
  incrementer_loggroup    = "/aws/lambda/${local.incrementer_fname}"
  incrementnold_fname     = "${var.unique_identifier}_lambda_incrementnold"
  incrementnold_loggroup  = "/aws/lambda/${local.incrementnold_fname}"
  incrementnoddb_fname    = "${var.unique_identifier}_lambda_incrementnoddb"
  incrementnoddb_loggroup = "/aws/lambda/${local.incrementnoddb_fname}"
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
