# Assignment 2 - Application Load Balancer evidence

This assignment demonstrates a common DevOps pattern: two EC2 web servers behind an Application Load Balancer (ALB), with the ALB acting as the public entry point.

The screenshots captured on **23 October 2026** show the same ALB DNS name returning two different responses: **Response from Web Server 1** and **Response from Web Server 2**. They document the browser test. Console evidence for the infrastructure configuration, target health, and direct-access restrictions is still to be added.

All **24 screenshots found directly on the Desktop** are collected in this folder. Screenshots **01–02** show the ALB browser test; **03–21** document the earlier VPC assignment; **22–24** are other coursework and a Terraform browser test. The older screenshots are included for context and do not verify the ALB configuration.

[Back to the AWS assignments](../../readme.md#2-application-load-balancer)

## Objective

Deploy two EC2 instances in the same VPC, using different Availability Zones where possible. Install a simple web server through user data and give each instance a distinct response. Route incoming HTTP traffic through an ALB in two public subnets, and restrict the instances' HTTP access to traffic from the ALB Security Group.

## Assignment architecture

```mermaid
flowchart TD
    Client[Internet client] -->|HTTP port 80| ALB
    subgraph VPC[Same VPC]
        ALB[Internet-facing Application Load Balancer<br/>Two public subnets in different Availability Zones]
        ALB -->|HTTP listener forwards requests| TG[Target group<br/>HTTP port 80 / health check path: /]
        TG --> EC2A[EC2 web server 1<br/>Distinct page content]
        TG --> EC2B[EC2 web server 2<br/>Distinct page content]
    end
```

This diagram illustrates the **required assignment design**. The browser screenshots below do not establish the VPC, subnet, Availability Zone, listener, or Security Group configuration.

## Evidence summary

| Requirement | Evidence available | Status |
| --- | --- | --- |
| Visit the ALB DNS name over HTTP | Both browser screenshots show the same ALB hostname | Captured |
| Receive different content from the two web servers | Screenshot 01 shows Web Server 1; screenshot 02 shows Web Server 2 | Captured |
| Two EC2 instances in one VPC, preferably across two Availability Zones | EC2 instance and networking details | Console evidence needed |
| Install the web servers using user data | User-data configuration for each instance | Console evidence needed |
| ALB in two public subnets with an HTTP port 80 listener | ALB network mapping and listener configuration | Console evidence needed |
| Both EC2 instances registered and healthy | Target group's registered targets and health status | Console evidence needed |
| Health check configured on `/` | Target group's health-check settings | Console evidence needed |
| ALB Security Group allows HTTP from anywhere | ALB Security Group's saved inbound rules | Console evidence needed |
| EC2 HTTP is allowed only from the ALB Security Group | EC2 Security Group's saved inbound rules and instance attachments | Console evidence needed |
| Direct internet access to EC2 is blocked | Instance network details, all attached Security Groups, and a direct-access test where applicable | Evidence needed |

Successful page responses do not establish that the targets are marked healthy or that direct access to the instances is blocked.

## Screenshots

The ALB tests appear first, followed by the VPC build sequence and the remaining Desktop screenshots. Every image has a numbered filename, a descriptive caption, and its original Desktop filename in the source index.

01. [ALB response — Web Server 1](screenshots/01-alb-response-web-server-1.png) — ALB.
02. [ALB response — Web Server 2](screenshots/02-alb-response-web-server-2.png) — ALB.
03. [VPC created](screenshots/03-vpc-created.png) — VPC.
04. [Public subnet](screenshots/04-vpc-public-subnet.png) — VPC.
05. [Private subnet](screenshots/05-vpc-private-subnet.png) — VPC.
06. [Internet gateway setup](screenshots/06-vpc-internet-gateway-create-form.png) — VPC.
07. [Internet gateway attachment](screenshots/07-vpc-internet-gateway-attach-form.png) — VPC.
08. [Unassociated Elastic IP](screenshots/08-vpc-elastic-ip-unassociated.png) — VPC.
09. [NAT gateway setup](screenshots/09-vpc-nat-gateway-create-form.png) — VPC.
10. [Public route table](screenshots/10-vpc-public-route-table-active.png) — VPC.
11. [Private route table setup](screenshots/11-vpc-private-route-table-create-form.png) — VPC.
12. [Private route setup](screenshots/12-vpc-private-route-edit-form.png) — VPC.
13. [Public Security Group setup](screenshots/13-vpc-public-security-group-create-form.png) — VPC.
14. [Public EC2 instance](screenshots/14-vpc-public-ec2-running.png) — VPC.
15. [Elastic IP list](screenshots/15-vpc-elastic-ip-list.png) — VPC.
16. [Public web endpoint](screenshots/16-vpc-public-web-endpoint.png) — VPC.
17. [Final VPC resource map](screenshots/17-vpc-final-resource-map.png) — VPC.
18. [NAT gateway details](screenshots/18-vpc-nat-gateway-available.png) — VPC.
19. [Private route and subnet association](screenshots/19-vpc-private-route-active-and-associated.png) — VPC.
20. [Route table inventory](screenshots/20-vpc-route-table-list-and-associations.png) — VPC.
21. [EC2 instance list](screenshots/21-vpc-ec2-instance-list.png) — VPC.
22. [CI/CD definitions](screenshots/22-coursework-ci-cd-definition.png) — Coursework.
23. [CI/CD pipeline overview](screenshots/23-coursework-ci-cd-pipeline.png) — Coursework.
24. [Terraform WordPress browser test](screenshots/24-terraform-wordpress-browser-test.png) — Terraform.

### 01. ALB response — Web Server 1

Response from Web Server 1 through the ALB DNS name, captured at 18:08:15 BST.

![ALB response — Web Server 1](screenshots/01-alb-response-web-server-1.png)


### 02. ALB response — Web Server 2

Response from Web Server 2 through the same ALB DNS name, captured at 18:08:21 BST.

![ALB response — Web Server 2](screenshots/02-alb-response-web-server-2.png)


### Earlier VPC assignment screenshots

These screenshots document Assignment 1. Their original write-up is available in the [VPC evidence README](../../aws-vpc-assignment/evidence/README.md). Reuse of this VPC for Assignment 2 has not been established by the supplied ALB screenshots.

<details>
<summary>View screenshots 03–21: VPC, routing, gateways, and the earlier EC2 instance</summary>


#### 03. VPC created

Assignment 1 VPC with CIDR 10.0.0.0/16.

![Assignment 1: VPC created](screenshots/03-vpc-created.png)


#### 04. Public subnet

Assignment 1 public subnet, 10.0.0.0/24 in eu-west-2a.

![Assignment 1: Public subnet](screenshots/04-vpc-public-subnet.png)


#### 05. Private subnet

Assignment 1 private subnet, 10.0.1.0/24 in eu-west-2b.

![Assignment 1: Private subnet](screenshots/05-vpc-private-subnet.png)


#### 06. Internet gateway setup

Creation form for assignment-1-IGW.

![Assignment 1: Internet gateway setup](screenshots/06-vpc-internet-gateway-create-form.png)


#### 07. Internet gateway attachment

Form selecting the Assignment 1 VPC for gateway attachment.

![Assignment 1: Internet gateway attachment](screenshots/07-vpc-internet-gateway-attach-form.png)


#### 08. Unassociated Elastic IP

Earlier Elastic IP detail with no association. The public address is masked in the existing repository copy.

![Assignment 1: Unassociated Elastic IP](screenshots/08-vpc-elastic-ip-unassociated.png)


#### 09. NAT gateway setup

Assignment 1 public NAT gateway creation form.

![Assignment 1: NAT gateway setup](screenshots/09-vpc-nat-gateway-create-form.png)


#### 10. Public route table

Active 0.0.0.0/0 route to the Internet Gateway and public-subnet association.

![Assignment 1: Public route table](screenshots/10-vpc-public-route-table-active.png)


#### 11. Private route table setup

Creation form for private-route-table.

![Assignment 1: Private route table setup](screenshots/11-vpc-private-route-table-create-form.png)


#### 12. Private route setup

Route-edit form before the saved state was captured; screenshot 19 shows the later active route.

![Assignment 1: Private route setup](screenshots/12-vpc-private-route-edit-form.png)


#### 13. Public Security Group setup

Assignment 1 HTTP and SSH rules restricted to My IP. This is a form, and the source addresses are masked.

![Assignment 1: Public Security Group setup](screenshots/13-vpc-public-security-group-create-form.png)


#### 14. Public EC2 instance

The single running public EC2 instance from Assignment 1; its public address is masked.

![Assignment 1: Public EC2 instance](screenshots/14-vpc-public-ec2-running.png)


#### 15. Elastic IP list

Assignment 1 Elastic IP inventory with the public address masked.

![Assignment 1: Elastic IP list](screenshots/15-vpc-elastic-ip-list.png)


#### 16. Public web endpoint

Assignment 1 browser test displays It works! through the public EC2 endpoint, whose address is masked.

![Assignment 1: Public web endpoint](screenshots/16-vpc-public-web-endpoint.png)


#### 17. Final VPC resource map

Assignment 1 map with two subnets, three route tables, an Internet Gateway, and a NAT Gateway.

![Assignment 1: Final VPC resource map](screenshots/17-vpc-final-resource-map.png)


#### 18. NAT gateway details

Assignment 1 public NAT gateway in Available state; its public address is masked.

![Assignment 1: NAT gateway details](screenshots/18-vpc-nat-gateway-available.png)


#### 19. Private route and subnet association

Active default route to the NAT gateway and explicit private-subnet association.

![Assignment 1: Private route and subnet association](screenshots/19-vpc-private-route-active-and-associated.png)


#### 20. Route table inventory

Assignment 1 public, private, and main route tables; the first row belongs to a different VPC.

![Assignment 1: Route table inventory](screenshots/20-vpc-route-table-list-and-associations.png)


#### 21. EC2 instance list

The Assignment 1 public instance with both instance status checks passed. This does not show ALB target health.

![Assignment 1: EC2 instance list](screenshots/21-vpc-ec2-instance-list.png)


</details>

### Other Desktop coursework screenshots

These complete the requested Desktop collection. They document other learning work and do not establish any ALB requirement.

<details>
<summary>View screenshots 22–24: CI/CD course slides and the Terraform WordPress test</summary>


#### 22. CI/CD definitions

CoderCo course slide covering continuous integration, delivery, and deployment.

![CI/CD definitions](screenshots/22-coursework-ci-cd-definition.png)


#### 23. CI/CD pipeline overview

CoderCo course slide showing the CI/CD pipeline and its benefits.

![CI/CD pipeline overview](screenshots/23-coursework-ci-cd-pipeline.png)


#### 24. Terraform WordPress browser test

The terraform project 1 WordPress page displaying the default Hello world! post.

![Terraform WordPress browser test](screenshots/24-terraform-wordpress-browser-test.png)


</details>

## Browser test result

The recorded ALB hostname is:

```text
assignment-2-alb-1488629408.eu-west-2.elb.amazonaws.com
```

Both screenshots use this hostname. The change in page content is consistent with requests reaching two different backend web servers. The hostname identifies the AWS Region as **Europe (London), `eu-west-2`**. These captures record the test at that time; they do not establish whether the endpoint is still running.

The test goal is to observe both distinct responses over repeated requests. AWS documents round robin as the default target-group routing algorithm; the configured algorithm for this build is not shown in the supplied screenshots. See [How Elastic Load Balancing works](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html).

## Required Security Group isolation

| Security Group | Direction | Protocol / port | Source or destination |
| --- | --- | --- | --- |
| ALB Security Group | Inbound | HTTP / TCP 80 | Source: `0.0.0.0/0` |
| ALB Security Group | Outbound | HTTP / TCP 80 for application traffic and health checks | Destination: EC2 Security Group |
| EC2 Security Group | Inbound | HTTP / TCP 80 | Source: ALB Security Group only |

These are the required rules, rather than a record of saved rules from this build. Capture the actual rules and their resource attachments before marking isolation as verified. Check every Security Group attached to each instance, because an additional group could allow broader access. If IPv6 is enabled, check its inbound rules too.

AWS recommends using the load balancer's Security Group as the source of the targets' inbound rule so the targets receive traffic exclusively from the load balancer. See [Security groups for your Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html).

## Source screenshots

| No. | Original Desktop filename | Repository copy |
| --- | --- | --- |
| 01 | `Screenshot 2026-10-23 at 18.08.15.png` | [01-alb-response-web-server-1.png](screenshots/01-alb-response-web-server-1.png) |
| 02 | `Screenshot 2026-10-23 at 18.08.21.png` | [02-alb-response-web-server-2.png](screenshots/02-alb-response-web-server-2.png) |
| 03 | `Screenshot 2026-10-12 at 02.01.31.png` | [03-vpc-created.png](screenshots/03-vpc-created.png) |
| 04 | `Screenshot 2026-10-12 at 02.29.26.png` | [04-vpc-public-subnet.png](screenshots/04-vpc-public-subnet.png) |
| 05 | `Screenshot 2026-10-12 at 02.33.25.png` | [05-vpc-private-subnet.png](screenshots/05-vpc-private-subnet.png) |
| 06 | `Screenshot 2026-10-12 at 02.35.14.png` | [06-vpc-internet-gateway-create-form.png](screenshots/06-vpc-internet-gateway-create-form.png) |
| 07 | `Screenshot 2026-10-12 at 02.36.14.png` | [07-vpc-internet-gateway-attach-form.png](screenshots/07-vpc-internet-gateway-attach-form.png) |
| 08 | `Screenshot 2026-10-12 at 02.37.57.png` | [08-vpc-elastic-ip-unassociated.png](screenshots/08-vpc-elastic-ip-unassociated.png) |
| 09 | `Screenshot 2026-10-12 at 02.45.32.png` | [09-vpc-nat-gateway-create-form.png](screenshots/09-vpc-nat-gateway-create-form.png) |
| 10 | `Screenshot 2026-10-12 at 02.59.05.png` | [10-vpc-public-route-table-active.png](screenshots/10-vpc-public-route-table-active.png) |
| 11 | `Screenshot 2026-10-12 at 03.00.06.png` | [11-vpc-private-route-table-create-form.png](screenshots/11-vpc-private-route-table-create-form.png) |
| 12 | `Screenshot 2026-10-12 at 03.03.33.png` | [12-vpc-private-route-edit-form.png](screenshots/12-vpc-private-route-edit-form.png) |
| 13 | `Screenshot 2026-10-12 at 03.13.38.png` | [13-vpc-public-security-group-create-form.png](screenshots/13-vpc-public-security-group-create-form.png) |
| 14 | `Screenshot 2026-10-13 at 12.17.50.png` | [14-vpc-public-ec2-running.png](screenshots/14-vpc-public-ec2-running.png) |
| 15 | `Screenshot 2026-10-13 at 12.19.58.png` | [15-vpc-elastic-ip-list.png](screenshots/15-vpc-elastic-ip-list.png) |
| 16 | `Screenshot 2026-10-13 at 12.21.15.png` | [16-vpc-public-web-endpoint.png](screenshots/16-vpc-public-web-endpoint.png) |
| 17 | `Screenshot 2026-10-17 at 17.28.24.png` | [17-vpc-final-resource-map.png](screenshots/17-vpc-final-resource-map.png) |
| 18 | `Screenshot 2026-10-17 at 17.29.11.png` | [18-vpc-nat-gateway-available.png](screenshots/18-vpc-nat-gateway-available.png) |
| 19 | `download.png` | [19-vpc-private-route-active-and-associated.png](screenshots/19-vpc-private-route-active-and-associated.png) |
| 20 | `download1.png` | [20-vpc-route-table-list-and-associations.png](screenshots/20-vpc-route-table-list-and-associations.png) |
| 21 | `Screenshot 2026-10-17 at 17.35.20.png` | [21-vpc-ec2-instance-list.png](screenshots/21-vpc-ec2-instance-list.png) |
| 22 | `Screenshot 2026-10-13 at 12.38.30.png` | [22-coursework-ci-cd-definition.png](screenshots/22-coursework-ci-cd-definition.png) |
| 23 | `Screenshot 2026-10-13 at 12.41.08.png` | [23-coursework-ci-cd-pipeline.png](screenshots/23-coursework-ci-cd-pipeline.png) |
| 24 | `Screenshot 2026-10-20 at 21.48.34.png` | [24-terraform-wordpress-browser-test.png](screenshots/24-terraform-wordpress-browser-test.png) |

## Privacy and screenshot integrity

The original Desktop files are unchanged. For 18 of the earlier VPC screenshots, this collection reuses the corresponding **existing redacted copies** from the VPC evidence folder, preserving the account and public-address masks already used in the repository. The two ALB captures, screenshot 21, and the three other coursework screenshots are unchanged copies of the Desktop files. Screenshot 21 is a different EC2 details view from the existing VPC repository image, so its original capture is included; its AWS account label and EC2 public address remain visible. No screenshot has been recreated or generated.

The ALB hostname remains visible so the two server responses can be matched to the same endpoint. All 24 images retain their source screenshot dimensions.

## Cleanup

Cleanup has not been evidenced in these captures. After completing the lab and saving the remaining evidence, remove resources created solely for this assignment: the ALB, target group, EC2 instances and unneeded attached storage, followed by unused assignment Security Groups. Remove any dedicated NAT Gateways or Elastic IPs only if they were created for this lab and are no longer needed. Keep shared VPC resources in place.

## Evidence still needed — to fill in at the end

To complete the evidence for all assignment tasks, capture:

- [ ] Both EC2 instances, their running state, shared VPC, Availability Zones, network details, and attached Security Groups.
- [ ] The user-data script on each instance, showing installation of the web server and its distinct page content.
- [ ] The ALB details and network mapping, showing an internet-facing Application Load Balancer in two public subnets across two Availability Zones. Include subnet route-table evidence of internet-gateway routing.
- [ ] The saved HTTP port 80 listener and its forwarding action to the target group.
- [ ] The target group's registered instances, both showing `Healthy`, and the saved HTTP health-check path `/`.
- [ ] The saved ALB and EC2 Security Group rules, showing the required source restrictions.
- [ ] Evidence that the instances cannot be reached directly from the internet. For instances without public addresses, show their network details. If an instance has a public address, record a direct HTTP connection attempt failing alongside the Security Group evidence.

Also record whether the lab resources have been cleaned up; the supplied screenshots do not show cleanup for Assignment 2.
