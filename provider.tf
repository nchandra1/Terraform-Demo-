### REQUIRED PROVIDER BLOCKS -NEED AWS PROVIDER FROM HASHICORP REGISTRY 
### CLOUD BLOCK -CONNECT CONFIG TO WORKSPACE AND CENTRALIZE STATE, SECURE ACCESS CREDENTIALS, EXECUTE REMOTE RUNS###

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

