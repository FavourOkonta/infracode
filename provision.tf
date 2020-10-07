provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "favtech-bucket"
    key    = "techbleat.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "first_node" {
  ami                    = "ami-0947d2ba12ee1ff75"
  instance_type          = "t2.micro"
  key_name               = "crossovertest"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  count                  = "1"
  user_data              = "${file("favour.sh")}"
  tags = {
    Name        = "Nginx"
    Provisioner = "Terraform"
    Test        = "yes_no"
  }
}
resource "aws_instance" "second_node" {
  ami                    = "ami-0947d2ba12ee1ff75"
  instance_type          = "t2.micro"
  key_name               = "crossovertest"
  vpc_security_group_ids = [aws_security_group.tomcat_sg.id]
  count                  = "1"
  user_data              = "${file("scripted.sh")}"
  tags = {
    Name        = "Tomcat"
    Provisioner = "Terraform"
  }
}
