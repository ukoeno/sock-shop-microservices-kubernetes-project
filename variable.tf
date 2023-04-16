# Name to be associated to all resources
variable "name" {
  default = "SSMKD"
}
# VPC Name
variable "vpc_name" {
  default = "SSMKD_VPC"
}
# Classless Inter-Domain Routing
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# Availability Zone 1
variable "az1" {
  default = "eu-west-2a"
}
# Availability Zone 2
variable "az2" {
  default = "eu-west-2b"
}
# Private Subnet 1
variable "prv-sn1" {
  default = "10.0.1.0/24"
}
# Private Subnet 2
variable "prv-sn2" {
  default = "10.0.2.0/24"
}
# Private Subnet 3
variable "prv-sn3" {
  default = "10.0.3.0/24"
}
# Private Subnet 4
variable "prv-sn4" {
  default = "10.0.4.0/24"
}
# Public Subnet 1
variable "pub-sn1" {
  default = "10.0.5.0/24"
}
# Public Subnet 2
variable "pub-sn2" {
  default = "10.0.6.0/24"
}
# Keypair Name
variable "keyname" {
  default = "ssmkd"
}
variable "Master-count" {
  default = 3
}
variable "Worker-count" {
  default = 2
}
variable "Stage_Master-count" {
  default = 3
}
variable "prod_haproxy" {
  default = 2
}
variable "stage_haproxy" {
  default = 2
}
variable "ami" {
  default = "ami-09744628bed84e434"
}
variable "instancetype" {
  default = "t3.medium"
}