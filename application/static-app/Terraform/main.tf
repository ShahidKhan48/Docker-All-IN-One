provider "aws" {
  region = "us-east-1" # Or your desired AWS region
}

# Terraform will automatically look for AWS credentials in
# environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
# or an IAM role if running on EC2.
