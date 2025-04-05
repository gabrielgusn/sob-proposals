terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws" {
    region = "sa-east-1"
    profile = "terraform"
}

resource "aws_budgets_budget" "cost-budget" {
  name = "monthly-budget"
  budget_type = "COST"
  limit_amount = "5.0"
  limit_unit = "USD"
  time_unit = "MONTHLY"
}