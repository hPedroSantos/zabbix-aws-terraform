# terraform.tfvars - ambiente DEV

region        = "us-east-2"
instance_type = "t3.medium"
key_name      = "zabbix-terraform"

# Seu IP público para SSH e HTTP
ip_root       = "<IP-PULICO-LOCALHOST>"

# IP da instância do Zabbix Server (privado dentro da VPC)
ip_server     = "10.0.0.5/32"

# IP da instância do Zabbix Proxy (privado dentro da VPC)
proxy_ip      = "10.0.0.10/32"

vpc_id        = "vpc-03fe5ecf1b9fa957a"
