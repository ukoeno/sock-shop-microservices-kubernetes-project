# VPC_id
variable "vpc" {
  default = "vpc-09e65c2c07a323881"
}
# Name Associated to all resources
variable "name" {
  description = "Name to be associated with all resources for this Project"
  type        = string
  default     = "SSMKD"
}
# All Accessible Ports In The Security group
variable "ssh_port" {
  default     = 22
  description = "this port allows ssh access"
}
variable "http_port" {
  default     = 80
  description = "this port allows http access"
}
variable "MYSQL_port" {
  default     = 3306
  description = "this port allows proxy access"
}
variable "all_access" {
  default = "0.0.0.0/0"
  description = "this port allows access from everywhere"
}
variable "proxy_port1" {
  default     = 8080
  description = "this port allows proxy access"
}
variable "proxy_port2" {
  default     = 9000
  description = "this port allows proxxy access"
}
variable "proxy_port3" {
  default     = 443
  description = "this port allows for SSL security"
}
variable "proxy_port4" {
  default = 6443
  description = "HAproxy"
}
variable "proxy_port5" {
  default = 30001
  description = "Application"
}
variable "proxy_port6" {
  default = 31090
  description = "Prometheus"
}
variable "proxy_port7" {
  default = 31300
  description = "Graphana"
}