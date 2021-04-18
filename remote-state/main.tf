terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32"
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "<BUCKET-NAME>"

  versioning {
    enabled = true
  }
}