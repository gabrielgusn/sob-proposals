resource "aws_budgets_budget" "cost_budget" {
  name = "monthly-budget"
  budget_type = "COST"
  limit_amount = "5.0"
  limit_unit = "USD"
  time_unit = "MONTHLY"
}
