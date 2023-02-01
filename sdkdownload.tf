# pip install --target ${path.module}/apps/incrementer launchdarkly-server-sdk

resource "null_resource" "ld_sdk_download_1" {
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = "pip install --target ${path.module}/apps/incrementer --upgrade launchdarkly-server-sdk"
  }
}

resource "null_resource" "ld_sdk_download_2" {
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = "pip install --target ${path.module}/apps/incrementld --upgrade launchdarkly-server-sdk"
  }
}
