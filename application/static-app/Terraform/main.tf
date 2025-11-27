# ec2 need to create

resource "aws_instance" "zoya-vm" {
  instance_type = "t3.micro"
  ami           = "ami-0c02fb55956c7d316"
  tags = {
    name = "zoya-vm"
  }
}


#default(vpc,securitygroup,storage 8gb default)
