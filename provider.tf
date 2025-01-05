terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.67.0"
    }
  }

  cloud {
    organization = "demo-terraform-jan"  
    workspaces {
      name = "Terraform-Demo-"  #name of workspace
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

