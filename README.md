# Terraform AWS WAFv2

This module creates Web ACLs for AWS WAFv2.
For now, it only supports rate-based rules with URL matching.

For WAF Classic, go to [scalair/terraform-aws-waf](https://github.com/scalair/terraform-aws-waf).

## Usage example

```hcl
module "wafv2" {
  source = "github.com/scalair/terraform-aws-wafv2"

  tags = {}

  cloudwatch_metrics_enabled = true

  acl_name           = "cloudfront_acl"
  acl_description    = "ACL for Cloudfront distributions"
  acl_scope          = "CLOUDFRONT"
  acl_default_action = "block" // block, BLOCK, allow, ALLOW
  acl_rules = [
    {
      name          = "rule1",
      action        = "count",
      type          = "rate_based",
      limit         = 100,
      search_string = "/path/to/protect",
    }
  ]
}
```
