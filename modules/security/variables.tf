variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "ssh_cidrs" {
  description = "List of public IP CIDRs allowed to access EC2 through SSH"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.ssh_cidrs : can(cidrnetmask(c))])
    error_message = "Each entry in ssh_cidrs must be a valid IPv4 CIDR block, e.g. 203.0.113.4/32."
  }

  validation {
    condition     = !contains(var.ssh_cidrs, "0.0.0.0/0")
    error_message = "ssh_cidrs must not contain 0.0.0.0/0. SSH must never be open to the whole internet."
  }
}

variable "enable_https" {
  description = "Whether to allow inbound HTTPS (443) from anywhere"
  type        = bool
  default     = true
}
