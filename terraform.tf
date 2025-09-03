terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
  # Configure S3 bucket as remote backend
  #backend "s3" {
  # bucket       = "terraform-state-bucket"
  #use_lockfile = true
  #key          = "path/to/my/key"
  #region       = "us-east-1"
  #}
}

