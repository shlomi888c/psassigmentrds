resource "aws_wafv2_web_acl" "web_acl" {
  name = "web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }
    visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}


resource "aws_wafv2_web_acl_association" "alb-waf" {
  resource_arn = concat(aws_lb.web-alb.*.arn, [""])[0]
  web_acl_arn = aws_wafv2_web_acl.web_acl.arn
}