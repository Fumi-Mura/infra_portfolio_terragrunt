# This is free resource
resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "${var.env}-${var.name}-iam-access-analyzer"
  type          = "ACCOUNT"

  tags = {
    Name = "${var.env}-${var.name}-iam-access-analyzer"
  }
}
