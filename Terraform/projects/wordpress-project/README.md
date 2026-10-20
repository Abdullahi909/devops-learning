# Terraform AWS Projects

These projects use Terraform to deploy AWS workloads and configure EC2 instances automatically at launch.

## WordPress on EC2

I used Terraform to provision an EC2 instance and its security group, then used instance startup configuration to install WordPress and its dependencies. The finished site is available through the instance's public endpoint.

This project gave me practical experience managing AWS resources with Terraform, passing configuration to an instance at launch, and checking the deployed application through a browser.

## EC2 configured with cloud-init

I used Terraform to launch an EC2 instance and pass it a cloud-init YAML file. On its first boot, cloud-init installs and configures a web server without requiring manual setup on the instance. I checked the result by opening the instance's endpoint.

This project shows how Terraform can provision infrastructure while cloud-init handles the operating system and software setup.
