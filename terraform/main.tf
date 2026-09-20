# 1. Look up the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 2. Create a Security Group (No inbound SSH port 22 required)
resource "aws_security_group" "instance_sg" {
  name_prefix        = "terraform-ec2-ssm-sg-"
  description = "Security group for EC2 instance with SSM access"

  # Allow all outbound traffic so instance can reach AWS SSM endpoints
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-ssm-sg"
  }
}

# 3. Launch the EC2 Instance
resource "aws_instance" "app_server" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "Terraform-SSM-Instance"
  }
}