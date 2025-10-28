variable "region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Key pair existente na AWS"
  type        = string
  default     = "zabbix-terraform"
}

variable "ip_root" {
  description = "Seu IP público para SSH/HTTP"
  type        = string
  default     = "191.26.75.254/32"
}

variable "ip_server" {
  description = "IP da instância Zabbix Server"
  type        = string
  default     = "10.0.0.5/32"
}

variable "proxy_ip" {
  description = "IP da instância Zabbix Proxy"
  type        = string
  default     = "10.0.1.10/32"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
  default     = "vpc-03fe5ecf1b9fa957a"
}
