provider "aws" {
    region = "eu-west-3"
}
resource "aws_instance" "ec2" {
#count = 1
ami = "ami-017d9f576d1635a77"
instance_type = "t2.micro"
subnet_id  = "subnet-0e3f0676677f3333e"
key_name = "ssh"

vpc_security_group_ids = ["sg-06c44fb2c7c8539a3", "sg-05b0a239e1b371ec3", "sg-0b561f065f5895a75"]


tags = {
    Name = "Worker1"
  }

provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key /opt/ansible/key.pem -i ${aws_instance.ec2.public_ip}, /opt/ansible/services_install_worker.yaml"
}
}

output "public_ips" {
  value = aws_instance.ec2.public_ip
}

output "public_dns" {
  value = aws_instance.ec2.public_dns
}

