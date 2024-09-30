# Region to build in
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Name of the user profile to use
variable "aws_profile" {
  type    = string
  default = "account2"
}

# Names of the EC2 instances to create
locals {
  instances = [
    "controlplane",
    "node01",
    "node02"
  ]
}

# Key pair to use
variable "aws_key_pair_name" {
  type    = string
  default = "vprofile-prod-key"
}
