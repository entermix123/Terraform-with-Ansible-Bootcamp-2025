data "aws_availability_zones" "available" {}  

data "aws_ami" "latest_ubuntu" {  
  most_recent = true
  owners      = ["099720109477"]  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]  
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[1]

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> my_private_ips.txt"
  }

  tags = {
    Name = "custom_instance"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}