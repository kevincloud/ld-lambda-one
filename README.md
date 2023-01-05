# LaunchDarkly Lambda Demo

## What is this anyway?

This demo shows how to use LaunchDarkly in a serverless environment. The resources include 2 Lambda functions, 1 DynamoDB table, an S3 static website, and the API Gateway. When the flag is off, the function increments a letter. When it's on, the function increments a number. The flag is created in the project you specify, and it's titled "Increment Number".

Once configured, you can stand this demo up in about 30 seconds.

This demo is not likely to blow your socks off, but it's the technology we're showcasing along with the art of the possible.

![Screenshot of Lambda Demo](https://github.com/kevincloud/ld-lambda-one/blob/main/assets/screenshot.png)

## Setting up the demo

### Prerequisites

1. Terraform is required. Make sure it's installed and accessible in your environment's path.
1. AWS Credentials - AWS Console --> IAM --> Users --> Add User. Enter username (i.e. YOURNAME-api) and select programmatic access. This user will need administrator access.
1. Once you have your access key and secret key, add them to your environment:

```
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
```

### Running Terraform

1. Clone this repo into your local environment.
1. Rename the `terraform.tfvars.example` file to `terraform.tfvars`.
1. Edit the `terraform.tfvars` file and enter your own information for each variable. Variable descriptions are in the `variables.tf` file.
1. Run the command `terraform init` to download all providers.
1. Run the command `terraform apply --auto-approve`.
1. When terraform finished, you'll be given a URL to your website. Plug it into your browser and start using the demo!

### Teardown

When you're finished, PLEASE tear it down. It's very, very easy. Just run the command `terraform destroy --auto-approve`

That's it! Everything is already wired up for you.

