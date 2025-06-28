# Secure VPC Terraform Module

This module creates a secure AWS VPC infrastructure with the following features:

## Security Features

1. **Network Isolation**
   - Separate public and private subnets
   - NAT Gateway for private subnet internet access
   - Custom route tables for traffic control

2. **Logging and Monitoring**
   - VPC Flow Logs enabled by default
   - CloudWatch Log Group with KMS encryption
   - IAM role with least privilege access

3. **Security Controls**
   - DNS hostnames enabled for service discovery
   - Encrypted flow logs
   - Customizable retention period

## Usage

```hcl
module "vpc" {
  source = "./modules/networking/vpc"

  environment = "prod"
  vpc_cidr    = "10.0.0.0/16"

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  availability_zones = [
    "us-west-2a",
    "us-west-2b"
  ]

  enable_nat_gateway = true
  enable_flow_logs   = true
  
  kms_key_arn = "arn:aws:kms:region:account:key/key-id"

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.0 |
| aws | >= 5.70.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| private_subnets | List of private subnet CIDR blocks | `list(string)` | n/a | yes |
| public_subnets | List of public subnet CIDR blocks | `list(string)` | n/a | yes |
| availability_zones | List of availability zones | `list(string)` | n/a | yes |
| enable_nat_gateway | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| enable_flow_logs | Enable VPC Flow Logs | `bool` | `true` | no |
| flow_logs_retention_days | Number of days to retain VPC Flow Logs | `number` | `30` | no |
| kms_key_arn | ARN of KMS key for encrypting flow logs | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| private_subnet_ids | List of private subnet IDs |
| public_subnet_ids | List of public subnet IDs |
| nat_gateway_ids | List of NAT Gateway IDs |
| private_route_table_ids | List of private route table IDs |
| public_route_table_id | ID of the public route table |
| flow_logs_group_name | Name of the CloudWatch Log Group for VPC Flow Logs |
| flow_logs_role_arn | ARN of the IAM role for VPC Flow Logs |

## Security Considerations

1. **Network Segmentation**
   - Private subnets have no direct internet access
   - Public subnets are limited to necessary services
   - NAT Gateway provides controlled outbound access

2. **Monitoring**
   - Flow logs capture all network traffic
   - Logs are encrypted using KMS
   - Customizable retention period for compliance

3. **Access Control**
   - IAM roles follow least privilege principle
   - Network ACLs and security groups should be added
   - Route tables control traffic flow

## Input Validation

This module includes comprehensive input validation to ensure security best practices:

1. **VPC CIDR Validation**
   - Must be a valid CIDR block
   - Should use private IP address ranges (RFC 1918)

2. **High Availability Requirements**
   - At least 2 private subnets required
   - At least 2 availability zones required
   - Availability zones must be unique

3. **Security Monitoring**
   - Flow logs retention must be valid CloudWatch period
   - Minimum 30 days retention for security monitoring

## Best Practices

1. Always enable flow logs for network monitoring
2. Use KMS encryption for sensitive data
3. Implement multiple AZs for high availability
4. Tag resources appropriately
5. Review and audit network flows regularly
6. Use version constraints for Terraform and providers
7. Follow naming conventions for consistency
