terraform {
  backend "s3" {
    bucket  = "galoy-test-terraform-state"
    key     = "galoy-test/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform"
  }
}
