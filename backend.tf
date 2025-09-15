terraform {
  backend "s3" {
    bucket         = "terraformstatefile090909"
    key            = "vpc-for-eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
