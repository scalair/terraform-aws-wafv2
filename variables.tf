variable "acl_name" {
    type = string
}

variable "acl_description" {
    type = string
}

variable "acl_scope" {
    type = string
}

variable "acl_default_action" {
    type = string
    default = "block"
}

variable "acl_rules" {
    type = list(any)
}

variable "acl_alb_arn" {
    type = string
    default = ""
}

variable "cloudwatch_metrics_enabled" {
    type = bool
    default = false
}

variable "tags" {
    type = map(any)
}
