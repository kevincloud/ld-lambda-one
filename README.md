# LaunchDarkly Lambda Demo

### What is this anyway?

This demo shows how to use LaunchDarkly in a serverless environment. The resources include 2 Lambda functions, 1 DynamoDB table, an S3 static website, and the API Gateway. When the flag is off, the function increments a letter. When it's on, the function increments a number. Once configured, you can stand this demo up in about 30 seconds.

![Screenshot of Lambda Demo](https://myoctocat.com/assets/images/base-octocat.svg)

### Setting up the demo

1. Terraform is required. Make sure it's installed and accessible in your environment's path.
1. Rename the `terraform.tfvars.example` file to `terraform.tfvars`
1. Edit the `terraform.tfvars` file and enter your own information for each variable. Variable descriptions are in the `variables.tf` file.
1. Run the command `terraform apply --auto-approve`
1. When finished, you'll be provided a URL to your website. Plug it into your browser and start using the demo!
1. When you're finished, PLEASE tear it down. It's very, very easy. Just run the command `terraform destroy --auto-approve`

That's it! Everything is already wired up for you.
