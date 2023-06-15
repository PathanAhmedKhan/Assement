# Configure AWS provider
provider "aws" {
  region = "us-east-1"  
}

# Create security group for EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"

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
    Name = "instance-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-022e1a32d3f742bd8"  
  instance_type = "t2.micro" 

  user_data = <<-EOF
#!/bin/bash
docker run -d -p 80:80 nginx:latest
EOF

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "nginx-instance"
  }
}


