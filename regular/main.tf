provider "aws" {
    region = "eu-west-3"
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow incoming traffic on port 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name_prefix = "ssh-"
  description = "Security group to allow SSH access"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0 
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
#count = 1
ami = "ami-017d9f576d1635a77"
instance_type = "t2.micro"
availability_zone = "eu-west-3a"
key_name = "ssh1"
vpc_security_group_ids = [aws_security_group.http.id, aws_security_group.ssh.id]

tags = {
    Name = "Client1"
  }

}

output "public_ips" {
  value = aws_instance.ec2.public_ip
}

output "public_dns" {
  value = aws_instance.ec2.public_dns
}

