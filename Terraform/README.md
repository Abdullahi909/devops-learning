# Terraform

I use this folder to practise defining AWS infrastructure as code. The exercises cover provider and state configuration, EC2 resources, reusable modules, inputs and outputs, and instance setup at launch.

## EC2 module exercise

The root configuration calls a local EC2 module. The module launches two EC2 instances using a shared AMI and an instance type input.

- [provider.tf](provider.tf) configures the AWS provider and the S3 state backend.
- [main.tf](main.tf) passes the instance type into the EC2 module.
- [variables.tf](variables.tf) declares the root module's instance type input.
- [modules/ec2/ec2.tf](modules/ec2/ec2.tf) defines the EC2 instances.
- [modules/ec2/variables.tf](modules/ec2/variables.tf) declares the module input, AMI local, and instance ID output.
- [.terraform.lock.hcl](.terraform.lock.hcl) records the selected provider version and checksums.

## AWS projects

The project notes cover two deployments: [WordPress on EC2 and an EC2 web server configured with cloud-init](projects/README.md).
