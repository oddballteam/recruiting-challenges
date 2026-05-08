terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}


module "ecr" {
  source               = "../modules/ecr"
  image_names          = ["${var.namespace}-${var.name}"]
  image_tag_mutability = "IMMUTABLE"
  scan_images_on_push  = var.scan_images_on_push
  tags = {
    Terraform = "true"
    namespace = var.namespace
    app       = var.name
  }
}
