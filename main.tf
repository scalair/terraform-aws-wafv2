resource "aws_wafv2_web_acl" "acl_rules" {
  name        = var.acl_name
  description = var.acl_description
  scope       = var.acl_scope

  default_action {
    dynamic "block" {
      for_each = upper(var.acl_default_action) == "BLOCK" ? [1] : []
      content {}
    }
    dynamic "allow" {
      for_each = upper(var.acl_default_action) == "ALLOW" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = { for i, rule in var.acl_rules : i => rule }

    content {
      name     = rule.value.name
      priority = 1 + rule.key

      action {
        dynamic "block" {
          for_each = upper(rule.value.action) == "BLOCK" ? [1] : []
          content {}
        }
        dynamic "allow" {
          for_each = upper(rule.value.action) == "ALLOW" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = upper(rule.value.action) == "COUNT" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate_based" ? [1] : []
          content {
            limit              = rule.value.limit
            aggregate_key_type = "IP"
            scope_down_statement {
              byte_match_statement {
                search_string         = rule.value.search_string
                positional_constraint = "STARTS_WITH"
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                field_to_match {
                  uri_path {}
                }
              }
            }
          }
        }
      }

      visibility_config {
        metric_name                = rule.value.name
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        sampled_requests_enabled   = true
      }

    }
  }

  visibility_config {
    metric_name                = var.acl_name
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "acl_association" {
  count = var.acl_scope == "REGIONAL" ? 1 : 0

  resource_arn = var.acl_alb_arn
  web_acl_arn  = aws_wafv2_web_acl.acl_rules.arn
}
