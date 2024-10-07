variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "purpose" {
  type = string
}

variable "policy_statement" {
  type = list(object({
    effect      = string
    actions     = optional(list(string), [])
    not_actions = optional(list(string), [])
    resource    = optional(list(string), [])
    not_actions = optional(list(string), [])
    condition = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  default     = []
  description = "IAM policy statement list."
}
