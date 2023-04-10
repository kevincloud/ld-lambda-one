resource "launchdarkly_feature_flag" "building_materials" {
  project_key = var.ld_project_key
  key         = "incNumber"
  name        = "Increment Number"

  variation_type = "boolean"

  variations {
    value = "true"
  }
  variations {
    value = "false"
  }

  defaults {
    on_variation  = 0
    off_variation = 1
  }

  tags = {
    lifecycle = "terraform"
  }
}
