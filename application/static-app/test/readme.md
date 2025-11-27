1. terraform installation & lab setup

2. writing codes:
   1. provider ( provider.tf.  -> backend.tf)
   2. main.tf  (variables.tf ,  terraform.tfvars , modules)

3. codes types :
    resource   resource-types. resource-name{
        code ,config , setting
    }

    example of resource-types:   ec2 ,   vpc.   , subnet ,  iam  , s3 , db 
 
    ###resource-types = providerName_resourcetypes = aws_ec2_instances ,aws_s3_bucket

    ## terraform registory to see all codes: 
    https://registry.terraform.io/?product_intent=terraform
    
    examples: ec2 creating - aws console login- ec2 -launch instance
     1. name 
     2.machine types t3-medium , lahb
     3. os images (AMI ID) ubuntu , amazon linux ,
     4. network config(vpc , subt ip)
     5. disk config  - 8gb 
     6. security group - port 22 ,90
     7. key-pair create - abc .pem-ok launch
     8. after creating vm , ec2 access via remote using public ip and .pem key 



# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/id_rsa.pub") # Generate with: ssh-keygen -t rsa
}
