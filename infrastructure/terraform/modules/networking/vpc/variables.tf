variable "environment" {
  description = "Environment name for the VPC (e.g. dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  
  validation {
    condition = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The vpc_cidr must be a valid CIDR block."
  }
  
  validation {
    condition = contains(["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"], split("/", var.vpc_cidr)[0]) || startswith(var.vpc_cidr, "10.") || startswith(var.vpc_cidr, "172.") || startswith(var.vpc_cidr, "192.168.")
    error_message = "The vpc_cidr should use private IP address ranges (10.0.0.0/8, 172.16.0.0/12, or 192.168.0.0/16)."
  }
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  
  validation {
    condition = length(var.private_subnets) >= 2
    error_message = "At least 2 private subnets are required for high availability."
  }
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  
  validation {
    condition = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones are required for high availability."
  }
  
  validation {
    condition = length(var.availability_zones) == length(distinct(var.availability_zones))
    error_message = "Availability zones must be unique."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 30
  
  validation {
    condition = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.flow_logs_retention_days)
    error_message = "The flow_logs_retention_days must be a valid CloudWatch Logs retention period."
  }
  
  validation {
    condition = var.flow_logs_retention_days >= 30
    error_message = "Flow logs retention should be at least 30 days for security monitoring."
  }
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encrypting flow logs"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
