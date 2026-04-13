
resource "aws_instance" "k8" {
  ami           = local.ami_id
  #instance_type = "t3.micro"
  instance_type = "t3.medium"
  vpc_security_group_ids =[ aws_security_group.allow_all.id ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("docker.sh") 
  
  tags = {
    Name = "${var.project}-${var.environment}-kubernites"
  }
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"

   ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  lifecycle {
      create_before_destroy = true
    }

  tags = {
    Name = "allow-all"
  }
}