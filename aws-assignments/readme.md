# AWS ClickOps Portfolio

I’m building three hands-on AWS projects through the AWS Management Console (ClickOps). This repository records the architecture, console configuration, security decisions, screenshots, validation, and cleanup for each project as I work through it.

## Projects

| Project | AWS services | Focus |
| --- | --- | --- |
| [1. VPC and Networking](#1-vpc-and-networking) | VPC, subnets, route tables, Internet Gateway, NAT Gateway, EC2 | Network segmentation and controlled internet access |
| [2. Application Load Balancer](#2-application-load-balancer) | Application Load Balancer, EC2, target groups, Security Groups | Health checks and routing traffic to multiple instances |
| [3. S3 Static Website, CloudFront, and Route 53](#3-s3-static-website-cloudfront-and-route-53) | S3, CloudFront, Route 53, ACM | Static hosting, CDN caching, HTTPS, and DNS |

## 1. VPC and Networking

**Objective:** Build a custom VPC with one public subnet and one private subnet, then deploy an EC2 instance in each and verify their different network access.

### Build

- Create a custom VPC, for example `10.0.0.0/16`, with a public and private subnet.
- Attach an Internet Gateway to the VPC.
- Create a NAT Gateway in the public subnet and associate an Elastic IP with it.
- Route public-subnet internet traffic through the Internet Gateway.
- Route private-subnet outbound internet traffic through the NAT Gateway.
- Launch a public EC2 instance with a public IP and a private EC2 instance without one.
- Restrict public-instance SSH and HTTP access to my IP. Allow private-instance access only from approved internal sources.

### Validate

- Check that the public instance is reachable only from the allowed source.
- Check that the private instance has no public IP and cannot be reached directly from the internet.
- Verify that the private instance can make outbound connections through the NAT Gateway.
- Capture the VPC, subnet, route-table, and Security Group settings.

## 2. Application Load Balancer

**Objective:** Deploy two EC2 web servers behind an Application Load Balancer (ALB). The ALB handles incoming HTTP traffic, and the instances are not directly accessible from the internet.

### Build

- Launch two EC2 instances in the same VPC, using different Availability Zones where possible.
- Use user data to install a web server and return different content from each instance.
- Create an internet-facing ALB in two public subnets across two Availability Zones.
- Create a target group, register both instances, and configure an HTTP health check on `/`.
- Add an HTTP listener on port 80 that forwards requests to the target group.
- Allow HTTP from the internet to the ALB Security Group. Allow HTTP to the EC2 Security Group only from the ALB Security Group.
- Keep the EC2 instances inaccessible directly from the internet; use private subnets and no public IPs where possible.

### Validate

- Check that both target-group instances become healthy.
- Visit the ALB DNS name and make repeated requests to confirm both instances serve their distinct responses.
- Confirm direct public access to the EC2 instances is blocked.
- Capture the listener, target group, health check, and Security Group settings.

## 3. S3 Static Website, CloudFront, and Route 53

**Objective:** Host a static website in S3, deliver it through CloudFront, and connect a Route 53 domain if available.

### Build

- Create an S3 bucket, enable static website hosting, and upload `index.html` and `error.html`.
- Configure the website objects for public reading as required by the S3 website-endpoint version of this lab.
- Create a CloudFront distribution using the S3 website endpoint as its origin.
- Enable HTTPS for visitors and compression. Use the Managed-CachingOptimized cache policy and allow `GET` and `HEAD` in the default behavior.
- If using a custom domain, create or use a Route 53 hosted zone, request an ACM certificate, and point an Alias record to the CloudFront distribution.
- Change `index.html`, invalidate the CloudFront cache, and confirm the updated page is served.

### Security design note

This lab uses a public S3 website endpoint as its baseline. AWS documents that this endpoint does not support OAC and that CloudFront connects to it over HTTP; HTTPS for visitors is a separate connection. I’ll document this trade-off and compare it with a private S3 bucket origin secured by CloudFront Origin Access Control (OAC).

- [CloudFront HTTPS connections to S3 origins](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-https-cloudfront-to-s3-origin.html)
- [Restrict access to an S3 origin with CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-origin.html)

### Validate

- Confirm the site loads through CloudFront and through the custom domain if configured.
- Verify caching by changing the page, invalidating the cache, and checking the updated response.
- Capture the origin, bucket access policy, HTTPS, DNS, and cache settings.

## Project evidence

For each project, I’m keeping an architecture diagram, console screenshots, configuration notes, validation results, security and cost decisions, and resource cleanup steps. Screenshots will exclude credentials and sensitive account details.

## AWS study material

- [AWS module cheat sheet](../AWS_CHEAT_SHEET.md) — AWS concepts, architecture patterns, and troubleshooting notes
- [ECS on EC2 vs. Fargate diagram (SVG)](../ecs-ec2-vs-fargate-architecture.svg)
- [ECS on EC2 vs. Fargate diagram (PNG)](../ecs-ec2-vs-fargate-architecture.png)
- [DevOps learning tracker](../DEVOPS_LEARNING_TRACKER.md) — study areas and progress notes
