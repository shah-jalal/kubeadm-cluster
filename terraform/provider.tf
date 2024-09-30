###############################################################
#
# This file contains the provider decalarations
#
###############################################################

# terraform {
#   required_providers {
#     localos = {
#       source  = "fireflycons/localos"
#       version = "0.1.2"
#     }
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      "tf:stackid" = "kubeadm-cluster"
    }
  }
}