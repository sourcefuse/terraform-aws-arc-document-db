# Terraform AWS ARC Document DB Module Usage Guide

## Introduction

### Purpose of the Document

This document provides guidelines and instructions for users looking to implement the Terraform AWS ARC Document DB module to provision an Amazon Document DB cluster.

### Module Overview

The [terraform-aws-arc-document-db](https://github.com/sourcefuse/terraform-aws-arc-document-db) 

### Prerequisites

Before using this module, ensure you have the following:

- AWS credentials configured.
- Terraform installed.
- A working knowledge of AWS Document DB cluster.

## Getting Started

### Module Source

To use the module in your Terraform configuration, include the following source block:

```hcl
module "example_doc_db_cluster" {
  source = "sourcefuse/arc-document-db/aws"
  // we recommend to pin the version we aren't simply for an example reference against our latest changes.
  version = "2.6.3"
  # insert the 6 required variables here
}
```

### Integration with Existing Terraform Configurations

Integrate the module with your existing Terraform mono repo configuration, follow the steps below:

1. Create a new folder in `terraform/` named `document-db`.
2. Create the required files, see the [examples](https://github.com/sourcefuse/terraform-aws-arc-document-db/tree/main/examples/simple) to base off of.
3. Configure with your backend
  - Create the environment backend configuration file: `config.<environment>.hcl`
    - **region**: Where the backend resides
    - **key**: `<working_directory>/terraform.tfstate`
    - **bucket**: Bucket name where the terraform state will reside
    - **dynamodb_table**: Lock table so there are not duplicate tfplans in the mix
    - **encrypt**: Encrypt all traffic to and from the backend

### Required AWS Permissions

Ensure that the AWS credentials used to execute Terraform have the necessary permissions to create Document DB cluster.

## Module Configuration

### Input Variables

For a list of input variables, see the README [Inputs](https://github.com/sourcefuse/terraform-aws-arc-document-db?tab=readme-ov-file#inputs) section.

### Output Values

For a list of outputs, see the README [Outputs](https://github.com/sourcefuse/terraform-aws-arc-document-db?tab=readme-ov-file#outputs) section.

## Module Usage

### Basic Usage

For basic usage, see the [example](https://github.com/sourcefuse/terraform-aws-arc-document-db/tree/main/example) folder.

## Troubleshooting

### Reporting Issues

If you encounter a bug or issue, please report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-document-db/issues).

## Security Considerations

### AWS VPC

Understand the security considerations related to Document DB clusters on AWS when using this module.

### Best Practices for AWS Document DB

Follow best practices to ensure secure Document DB configurations:

- [Document DB security on AWS](https://docs.aws.amazon.com/documentdb/latest/developerguide/security.html/)

## Contributing and Community Support

### Contributing Guidelines

Contribute to the module by following the guidelines outlined in the [CONTRIBUTING.md](https://github.com/sourcefuse/terraform-aws-arc-document-db/blob/main/CONTRIBUTING.md) file.

### Reporting Bugs and Issues

If you find a bug or issue, report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-document-db/issues).

## License

### License Information

This module is licensed under the Apache 2.0 license. Refer to the [LICENSE](https://github.com/sourcefuse/terraform-aws-arc-document-db/blob/main/LICENSE) file for more details.

### Open Source Contribution

Contribute to open source by using and enhancing this module. Your contributions are welcome!
