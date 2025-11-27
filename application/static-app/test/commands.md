# Terraform Commands

## Setup
```bash
# Generate SSH key pair (if not exists)
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa

# Configure AWS credentials
aws configure
```

## Terraform Workflow
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

## Connect to EC2
```bash
# SSH to instance (use output from terraform apply)
ssh -i ~/.ssh/id_rsa ec2-user@<PUBLIC_IP>
```