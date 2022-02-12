variable "aws_region" {
  description = "Region to provision resources"
  type        = string
  default     = "us-east-1"
}

variable "schedule_expression" {
  description = "how often to run the command"
  type        = string
  default     = "rate(60 minutes)"
}

variable "run_command_targets" {
  description = "list of EC2 instances to run command"
  type        = list(any)
  default     = [""]
}

