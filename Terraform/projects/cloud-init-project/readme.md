# Assignment 2: EC2 Deployment with Cloud-Init

## Objective

Use Terraform to launch an EC2 instance and pass it a cloud-init configuration through EC2 user data. On first boot, cloud-init should install and start NGINX without manual setup.

## What this project demonstrates

- Passing a cloud-init file to EC2 with Terraform `user_data`
- Automating software installation and configuration at boot
- Using Terraform variables and outputs to make the deployment reusable and easy to inspect

## Project files

- `provider.tf` — AWS provider configuration
- `main.tf` — EC2 instance and related resources
- `variables.tf` — configurable inputs
- `outputs.tf` — useful deployment details, such as the public IP
- `cloud-init.yaml` — software installation and startup configuration

## Deploy

Configure AWS credentials using your local AWS profile, then run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
