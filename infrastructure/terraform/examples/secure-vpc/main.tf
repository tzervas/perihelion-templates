terraform {
  required_version = ">= 1.8.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# KMS key for VPC Flow Logs encryption
resource "aws_kms_key" "vpc_logs" {
  description             = "KMS key for VPC Flow Logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowVPCFlowLogs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

# Alias for the KMS key
resource "aws_kms_alias" "vpc_logs" {
  name          = "alias/${var.environment}-vpc-flow-logs"
  target_key_id = aws_kms_key.vpc_logs.key_id
}

# VPC Module
module "vpc" {
  source = "../../modules/networking/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  private_subnets     = var.private_subnet_cidrs
  public_subnets      = var.public_subnet_cidrs
  availability_zones  = var.availability_zones

  enable_nat_gateway = true
  enable_flow_logs   = true
  
  kms_key_arn = aws_kms_key.vpc_logs.arn

  tags = local.tags
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Locals
locals {
  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Terraform   = "true"
      Project     = "secure-vpc"
    }
  )
}
