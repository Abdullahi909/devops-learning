# Terraform AWS Projects

This guide records the requirements, implementation notes, and verification evidence for my two Terraform AWS projects. Each project keeps its Terraform files and documentation together so the configuration can be reviewed and repeated.

## Project 1 — Deploy WordPress Using Terraform

### Objective

Provision an EC2 instance that installs WordPress and its dependencies at launch, then verify that the site is available through a public endpoint. Terraform manages the AWS resources end to end.

### Build requirements

- Configure the AWS provider and required EC2 settings.
- Define the EC2 instance and its Security Group in Terraform.
- Put configurable values in `variables.tf`, such as the instance type, AMI, and allowed SSH source.
- Expose useful instance details and the website endpoint through `outputs.tf`.
- Use embedded user data or a referenced user-data script to install and configure the web and database dependencies and WordPress.
- Restrict inbound access to the ports needed by the site; limit SSH to an administrator-controlled source.

### Verify and document

- Run Terraform's format, validation, and plan steps before applying changes.
- Confirm the instance finishes bootstrapping and the WordPress page loads at the output endpoint.
- Save a screenshot of the working site and document the required AWS resources and configuration choices.
- Destroy the lab resources when the work is complete and record the cleanup.

## Project 2 — EC2 Deployment with Cloud-Init

### Objective

Use a cloud-init YAML file to configure an EC2 instance automatically when it boots, without manually installing software after launch.

### Build requirements

- Create a cloud-init YAML file that installs and configures a web server such as NGINX or Apache.
- Pass the cloud-init content to the EC2 resource through Terraform using `user_data` or `user_data_base64`.
- Keep Terraform inputs and outputs clear; use a module if it makes the configuration easier to reuse.
- Return the instance ID and a usable endpoint as Terraform outputs.

### Verify and document

- Confirm cloud-init completes successfully and the web server starts after boot.
- Open the endpoint and verify the configured response without making manual changes on the instance.
- Document how Terraform supplies the cloud-init file, the important YAML settings, and the verification steps.
- Save screenshots or logs that show the successful result, then destroy the lab resources when finished.

## Suggested project layout

Keep each assignment self-contained as its Terraform files are added:

```text
projects/
├── README.md
├── wordpress/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh
└── cloud-init/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── cloud-init.yaml
```

## Evidence to keep

For both projects, include a short architecture explanation, the relevant Terraform and cloud-init files, validation results, screenshots of the working endpoint, and resource cleanup notes. Do not include credentials, Terraform state, or personal `.tfvars` values in the repository.
