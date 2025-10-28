terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Busca a AMI Ubuntu 22.04 mais recente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Subnet pública dentro da VPC existente
resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "public-subnet"
  }
}

# Security Group para Zabbix Server/Proxy
resource "aws_security_group" "zabbix_sg" {
  name        = "zabbix-sg-dev"
  description = "SG para Zabbix Server/Proxy"
  vpc_id      = var.vpc_id

  # MySQL (exemplo, se for usar)
  ingress {
    description = "MySQL Port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.ip_server]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_root]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ip_root]
  }

  # Zabbix Server
  ingress {
    description = "Zabbix Server"
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = [var.proxy_ip]
  }

  # Zabbix Agent
  ingress {
    description = "Zabbix Agent"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = [var.proxy_ip]
  }
}

# Instância EC2 para Zabbix Server
resource "aws_instance" "zabbix_central" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.zabbix_sg.id]

  private_ip = "10.0.0.6"  # IP fixo dentro da subnet
  associate_public_ip_address = true

  tags = {
    Name = "zabbix-central"
  }
}

# Output do IP público da instância
output "central_public_ip" {
  value = aws_instance.zabbix_central.public_ip
}
