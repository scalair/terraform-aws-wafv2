
output "acl_id" {
    value = aws_wafv2_web_acl.acl_rules.id
}

output "acl_arn" {
    value = aws_wafv2_web_acl.acl_rules.arn
}

output "acl_capacity" {
    value = aws_wafv2_web_acl.acl_rules.capacity
}