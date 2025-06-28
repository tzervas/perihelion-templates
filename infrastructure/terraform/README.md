# Terraform Security-First Templates

This directory contains security-focused Terraform templates for infrastructure provisioning.

## Templates Structure

```
terraform/
├── modules/                 # Reusable infrastructure modules
│   ├── networking/         # VPC, subnets, security groups
│   ├── identity/           # IAM roles and policies
│   ├── monitoring/        # Logging and monitoring resources
│   └── security/          # Security-specific resources
├── environments/           # Environment-specific configurations
│   ├── development/
│   ├── staging/
│   └── production/
└── examples/              # Example implementations
```

## Security Features

1. **Network Security**
   - VPC with private and public subnets
   - Network ACLs and security groups
   - VPC Flow Logs
   - Transit Gateway configurations

2. **Identity and Access Management**
   - Custom IAM roles with least privilege
   - Service account policies
   - Cross-account access controls
   - Identity federation support

3. **Encryption and Key Management**
   - KMS key management
   - S3 bucket encryption
   - EBS volume encryption
   - Secret management

4. **Monitoring and Logging**
   - CloudWatch Logs configuration
   - CloudTrail setup
   - Security Hub integration
   - GuardDuty configuration

5. **Compliance and Governance**
   - AWS Config rules
   - Security group policies
   - Resource tagging policies
   - Compliance reporting

## Backend Configuration

### Secure Remote State with S3 and DynamoDB

For production deployments, use a secure backend configuration:

```hcl
terraform {
  required_version = "~> 1.8.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15.0"
    }
  }

  backend "s3" {
    bucket         = "perihelion-terraform-state-prod"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "perihelion-terraform-locks"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    
    # Enable versioning and MFA delete on the S3 bucket
    versioning = true
    
    # Use assume role for cross-account access
    # role_arn = "arn:aws:iam::123456789012:role/terraform-execution-role"
  }
}
```

### Backend Setup

1. Create the S3 bucket for state storage:
   ```bash
   aws s3 mb s3://perihelion-terraform-state-prod --region us-west-2
   aws s3api put-bucket-versioning --bucket perihelion-terraform-state-prod --versioning-configuration Status=Enabled
   aws s3api put-bucket-encryption --bucket perihelion-terraform-state-prod --server-side-encryption-configuration '{
     "Rules": [{
       "ApplyServerSideEncryptionByDefault": {
         "SSEAlgorithm": "aws:kms",
         "KMSMasterKeyID": "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
       }
     }]
   }'
   ```

2. Create the DynamoDB table for state locking:
   ```bash
   aws dynamodb create-table \
     --table-name perihelion-terraform-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
     --region us-west-2
   ```

## Usage

1. Initialize the working directory:
   ```bash
   terraform init
   ```

2. Review the security configuration:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Version Pinning Best Practices

### Terraform Version Pinning
Always pin Terraform and provider versions to ensure reproducible and stable builds:

```hcl
terraform {
  # Pin Terraform version to a specific minor version
  required_version = "~> 1.8.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Pin to patch version for production
      version = "= 5.70.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.32.0"
    }
  }
}
```

### Module Version Pinning
When using external modules, always pin to specific versions:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "= 5.8.1"  # Pin to exact version
  
  # Module configuration...
}
```

### Version Management Strategy
- **Development**: Use `~>` for minor version constraints to get bug fixes
- **Staging**: Use `=` for exact versions to match production
- **Production**: Always use exact versions (`=`) for complete reproducibility

### Dependency Locking
Use Terraform's dependency lock file:

```bash
# Generate and commit .terraform.lock.hcl
terraform providers lock \
  -platform=linux_amd64 \
  -platform=darwin_amd64 \
  -platform=windows_amd64
```

## Security Best Practices

1. Always enable encryption at rest
2. Use private endpoints where possible
3. Implement proper tag management
4. Enable detailed monitoring
5. Regular security audits
6. Use remote state with encryption
7. Pin all Terraform and provider versions
8. Use dependency lock files in version control

## Testing

Each module includes:
- Security compliance tests
- Infrastructure validation tests
- Access control tests
- Resource configuration tests
