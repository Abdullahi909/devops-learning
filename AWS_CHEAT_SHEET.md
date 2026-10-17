# AWS module cheat sheet

Personal, reusable AWS reference for projects, labs, interviews, and day-to-day troubleshooting.

This guide is written around the AWS topics recovered from your learning chats and the ECS/EC2/Fargate architecture work in this project. It is intentionally AWS-only: Terraform, CI/CD, and GitHub Actions are not part of this document.

The goal is not to memorise random service names. The goal is to understand what each AWS building block does, where it sits, what it needs, and how to reason about a failure.

## Coverage checklist

Use this as a map of what is covered. If you can explain every line, you have a strong working foundation for the AWS module.

- [x] AWS account, regions, Availability Zones, edge locations, and shared responsibility
- [x] IP addresses, ports, listening processes, DNS, TCP/UDP, and HTTP/HTTPS
- [x] VPCs, CIDR blocks, subnets, route tables, local routes, Internet Gateways, and NAT Gateways
- [x] Public versus private subnets and public versus private IP addresses
- [x] ENIs, subnet address pools, AWS-reserved IPs, and why resources receive private IPs
- [x] Availability Zone design and multi-AZ high availability
- [x] Security Groups, Network ACLs, IAM, roles, policies, temporary credentials, and least privilege
- [x] EC2, AMIs, instance types, EBS, key pairs, user data, Elastic IPs, and lifecycle states
- [x] EC2 Auto Scaling Groups and the difference between instance scaling and task scaling
- [x] Amazon ECR, container images, tags, digests, repositories, and image access
- [x] Amazon ECS clusters, task definitions, tasks, services, desired count, deployments, and health
- [x] AWS Fargate versus ECS on EC2 and what AWS manages in each model
- [x] ECS networking, `awsvpc`, task ENIs, private tasks, NAT, and VPC endpoints
- [x] Application Load Balancers, listeners, rules, target groups, health checks, and TLS termination
- [x] Route 53 hosted zones, records, aliases, TTL, public DNS, private DNS, and service discovery
- [x] CloudFront distributions, origins, edge locations, caching, TTL, invalidation, and origin protection
- [x] S3, EBS, EFS, RDS, and choosing the right storage type
- [x] ACM certificates, HTTPS, WAF, Shield, and common edge security layers
- [x] CloudWatch Logs, metrics, dashboards, alarms, Application Signals, and traces
- [x] SNS notification flow and the difference between detection and notification
- [x] CloudTrail and VPC Flow Logs for audit and network evidence
- [x] Production architecture patterns, reliability, scaling, cost, and security checklists
- [x] Troubleshooting flows for DNS, connectivity, ALB, ECS, IAM, CloudFront, and monitoring

## Quick navigation

- [Learning path](#1-your-aws-learning-path-in-order)
- [AWS mental model](#2-aws-mental-model)
- [Networking foundations](#3-networking-foundations)
- [VPCs, CIDR blocks, and subnets](#4-vpcs-cidr-blocks-and-subnets)
- [Availability and network security](#5-availability-and-network-security)
- [IAM and AWS permissions](#6-iam-and-aws-permissions)
- [EC2 and Auto Scaling](#7-amazon-ec2)
- [ECR, ECS, and Fargate](#9-containers-ecr-and-ecs)
- [Application Load Balancer](#10-application-load-balancer)
- [Route 53 and CloudFront](#11-amazon-route-53-and-dns)
- [Storage](#13-storage-services-you-will-use-with-these-architectures)
- [Monitoring and alerting](#15-monitoring-logging-alerting-and-tracing)
- [Complete architecture](#16-the-complete-production-architecture)
- [Read-only CLI checks](#18-read-only-aws-cli-checks)
- [Troubleshooting runbooks](#19-troubleshooting-runbooks)
- [Production checklist](#20-production-readiness-checklist)
- [Glossary](#23-compact-glossary)

---

## 1. Your AWS learning path in order

This is the order that makes the ideas connect. Each stage answers a question raised in the next stage.

### 1.1 “Where does traffic go?” — IPs, ports, and listening

You started with the most useful networking idea:

> An IP address identifies the machine or network interface. A port identifies the application endpoint on that machine. A listening process is waiting for a connection on that IP and port.

Example:

```text
192.168.1.10:80
```

means “connect to port 80 on the device using `192.168.1.10`.” If Nginx is listening on port 80, it is ready to accept HTTP connections. An allowed firewall rule does not create a server; something must actually be listening.

The apartment analogy:

- IP address = the building address
- Port = the apartment or door number
- Application = the person or business behind the door
- Listening = the person is home and ready to answer
- Security Group rule = building security allows or blocks access to the door

Three separate checks are often confused:

1. Does DNS point to the right destination?
2. Do the network routes and security controls allow the connection?
3. Is an application listening on the destination port?

All three must be correct.

### 1.2 “How is AWS networking divided?” — VPCs, subnets, and Availability Zones

You then learned that a VPC is your private network boundary in AWS. A subnet is a smaller IP range inside the VPC, and every subnet belongs to one Availability Zone.

That gives the hierarchy:

```text
AWS Region
└── Availability Zone
    └── VPC
        └── Subnet
            └── Network interface / private IP
```

In practice, a VPC spans a Region, while a subnet is placed in one Availability Zone. To design for a zone failure, create matching subnets in multiple AZs.

### 1.3 “Why did the ALB require two AZs?” — resilient entry points

An Application Load Balancer is a managed service, but it still creates managed load-balancer nodes and network interfaces in the subnets you select. An internet-facing ALB needs subnets in at least two different Availability Zones.

The reason is availability: if one AZ has a problem, the ALB can continue routing through the other AZ when healthy targets are available.

The key clarification from your questions:

> A `/20` subnet is an address pool. It is not 4,096 IPs that the ALB consumes.

The ALB uses a small number of managed interfaces and may need more addresses while scaling or replacing nodes. The remaining addresses stay available for other resources or future capacity. AWS currently recommends that each ALB subnet have at least a `/27` CIDR and at least eight free IP addresses.

### 1.4 “What is the server?” — EC2 and AMIs

EC2 is AWS’s virtual-server service. You choose the hardware profile with an instance type and choose the starting operating-system image with an AMI.

An AMI is the template used to boot the instance. It normally contains an operating system, a root disk layout, and possibly preinstalled software.

```text
AMI = what the server starts from
Instance type = how much compute capacity it has
Subnet = where its private network interface is placed
Security Group = what network traffic can reach it
IAM role = what AWS actions software on it may perform
```

### 1.5 “How do containers run?” — ECR, ECS, and Fargate

The container flow from your project diagrams is:

```text
Application code
    ↓
Docker image
    ↓
Amazon ECR repository
    ↓
ECS task definition
    ↓
ECS task
    ↓
ECS service maintains the desired number of tasks
    ↓
Fargate or EC2 supplies the compute capacity
```

ECR stores the image. ECS defines and schedules the container. Fargate or EC2 provides the place where the container runs.

### 1.6 “Who can connect and who can take AWS actions?” — Security Groups and IAM

This was one of the most important distinctions you learned:

> Security Group = network access. IAM = AWS API and resource permissions.

An ALB Security Group can allow HTTPS from users, while an IAM role allows a task to read a specific S3 bucket. These controls solve different problems and can independently block an operation.

### 1.7 “How do users find and reach the application?” — Route 53 and CloudFront

Route 53 translates a name such as `api.example.com` into a destination. CloudFront places a caching and delivery layer close to users. Depending on the request, CloudFront can use an S3 bucket or an ALB as its origin.

Typical flows:

```text
User → Route 53 → CloudFront → ALB → ECS tasks
User → Route 53 → CloudFront → S3
```

CloudFront is not the application server. It is the edge delivery layer in front of the origin.

### 1.8 “How do I know the system is healthy?” — CloudWatch and SNS

CloudWatch collects logs and metrics, creates dashboards, and evaluates alarms. SNS is commonly used to deliver an alarm notification to email, an incident system, or another subscriber.

```text
Application / ALB / ECS
        ↓ logs and metrics
CloudWatch
        ↓ alarm state
SNS
        ↓ notification
Email / incident platform / automation
```

CloudWatch detects. SNS distributes the notification. They are related but not interchangeable.

---

## 2. AWS mental model

### 2.1 AWS account

An AWS account is a security and billing boundary. It contains resources, identities, policies, service quotas, and billing activity.

Good habits:

- Do not use the root user for everyday work.
- Enable MFA on the root user and privileged identities.
- Keep production and non-production separated when the project requires it.
- Use clear tags such as `Project`, `Environment`, `Owner`, and `CostCentre`.
- Know which Region a resource belongs to before searching for it in the console.

### 2.2 Region

A Region is a geographic AWS location such as London (`eu-west-2`). Most regional resources exist only in the Region where you create them.

Region affects:

- Which AMIs, subnets, and Availability Zones are available
- Where data is stored
- Latency to users
- Service availability and quotas
- Pricing

An AMI ID from one Region normally cannot be used directly in another Region. The same applies to many resource IDs.

### 2.3 Availability Zone

An Availability Zone is an isolated location within a Region. AWS designs AZs to reduce the chance that one failure affects every AZ in the Region.

High availability usually means spreading independent copies across at least two AZs:

```text
Region: eu-west-2
├── eu-west-2a
│   ├── public subnet
│   └── private application subnet
└── eu-west-2b
    ├── public subnet
    └── private application subnet
```

Two AZs do not automatically make an application highly available. You also need healthy capacity in both AZs, working routes, working health checks, and a design that does not depend on one remaining component.

### 2.4 Edge location and Regional Edge Cache

CloudFront uses a global network of Points of Presence and regional edge caches. These are different from your VPC subnets and Availability Zones. Their purpose is to deliver cached content closer to viewers.

### 2.5 Managed versus self-managed

AWS may manage the underlying servers while you still configure the service.

Examples:

- With EC2, you manage the guest operating system, installed packages, and application process.
- With Fargate, AWS manages the underlying compute capacity; you provide task definitions, images, networking, and desired tasks.
- With an ALB, AWS manages the load-balancer nodes; you configure listeners, rules, target groups, subnets, and security groups.
- With S3, AWS manages storage infrastructure; you configure buckets, objects, policies, encryption, lifecycle, and access.

Managed does not mean “no responsibility.” It means the boundary of your responsibility moves.

### 2.6 Shared responsibility model

AWS secures the infrastructure that runs its cloud services. You remain responsible for what you configure and put in those services.

Your responsibilities commonly include:

- IAM users, roles, permissions, and MFA
- Network exposure and Security Groups
- Operating-system patching on EC2
- Application vulnerabilities and secrets
- Data access policies and encryption choices
- Log retention and incident response
- Backups and recovery testing

The exact boundary changes by service. You manage more on EC2 than on Fargate, Lambda, or S3.

### 2.7 Resource names, IDs, and ARNs

AWS resources usually have:

- A human-readable name or tag
- A service-specific ID such as `i-0123456789abcdef0`, `sg-0123456789abcdef0`, or `subnet-0123456789abcdef0`
- An ARN, the globally structured identity used by IAM policies

Example ARN shape:

```text
arn:aws:s3:::example-bucket
arn:aws:iam::123456789012:role/AppTaskRole
```

When troubleshooting, confirm the account, Region, resource ID, and ARN. Many “missing resource” problems are actually Region or account mistakes.

---

## 3. Networking foundations

### 3.1 IP address

An IPv4 address is a 32-bit address written as four decimal octets, for example `192.168.1.10`.

There are two important categories in AWS:

- Private IP: used inside the VPC and its connected networks
- Public IPv4: used for internet communication through an Internet Gateway or managed service

The instance normally uses its private address internally. AWS can translate between a public IPv4 address and the private address at the Internet Gateway boundary.

### 3.2 Port

A port is a logical endpoint for a network service on an IP address.

Common ports:

| Port | Typical use | Protocol |
| --- | --- | --- |
| 22 | SSH | TCP |
| 53 | DNS | UDP/TCP |
| 80 | HTTP | TCP |
| 443 | HTTPS | TCP |
| 3000 | Common development web server | TCP |
| 8080 | Common alternate HTTP port | TCP |
| 5432 | PostgreSQL | TCP |
| 3306 | MySQL/MariaDB | TCP |

Port numbers are conventions, not proof of what is actually running. The application configuration and listener state are authoritative.

### 3.3 Listening versus open

These are related but different:

- Listening: a process has bound to a local IP and port and is waiting for connections.
- Allowed: network controls permit packets to reach that destination.
- Reachable: the full path works from the client to the destination.

Example:

```text
Security Group allows TCP 80
but Nginx is not listening on TCP 80
→ the connection still fails
```

The reverse also fails:

```text
Nginx listens on TCP 80
but the Security Group blocks TCP 80
→ the connection still fails
```

On Linux, useful checks include:

```bash
ss -lntp
curl -v http://127.0.0.1:80
```

### 3.4 DNS

DNS maps names to records. It is not the same as HTTP and it does not itself open a network connection.

The basic flow is:

```text
api.example.com
        ↓ DNS lookup
destination name or address
        ↓ TCP/TLS connection
application endpoint
```

If DNS returns the wrong destination, a perfectly healthy application can appear broken. If DNS is correct but the port or route is blocked, the lookup succeeds but the connection fails.

Useful checks:

```bash
dig api.example.com
nslookup api.example.com
curl -v https://api.example.com/health
```

### 3.5 TCP, UDP, HTTP, and HTTPS

- TCP provides ordered, reliable connections and is used by HTTP/HTTPS.
- UDP is connectionless and is commonly used for DNS queries, streaming, and latency-sensitive protocols.
- HTTP is application-level request/response traffic.
- HTTPS is HTTP protected by TLS encryption and certificate verification.

An ALB listener normally accepts HTTP or HTTPS. A Security Group rule normally specifies a transport protocol, destination port, and source.

---

## 4. VPCs, CIDR blocks, and subnets

### 4.1 VPC

Amazon VPC is your logically isolated network in AWS. It provides the address range and the network components used to connect resources.

A VPC contains or uses:

- IPv4 and optional IPv6 CIDR ranges
- Subnets
- Route tables
- Internet Gateways
- NAT Gateways
- Security Groups
- Network ACLs
- VPC endpoints
- VPC Flow Logs

The VPC itself is not a server. It is the network boundary and routing environment around the servers and services.

### 4.2 CIDR notation

CIDR describes a block of addresses. The suffix is the number of fixed network bits.

For IPv4:

```text
number of addresses = 2^(32 - prefix length)
```

Examples:

| CIDR | Total IPv4 addresses | AWS IPv4 subnet usable addresses |
| --- | ---: | ---: |
| `/16` | 65,536 | 65,531 |
| `/20` | 4,096 | 4,091 |
| `/24` | 256 | 251 |
| `/27` | 32 | 27 |
| `/28` | 16 | 11 |

AWS reserves five IPv4 addresses in every subnet: the network address, the VPC router address, the DNS address, the future-use address, and the broadcast address. AWS does not support IPv4 broadcast in the normal on-demand sense, but the address is still reserved.

Important distinction:

> A subnet size is capacity available for network interfaces. It is not the number of addresses currently consumed by a resource.

### 4.3 Subnet

A subnet is a contiguous range of IP addresses inside a VPC. A subnet is tied to one Availability Zone.

Resources create network interfaces in subnets and receive private IP addresses from the subnet range.

Example:

```text
VPC: 10.0.0.0/16
├── Public subnet A: 10.0.1.0/24, eu-west-2a
├── Public subnet B: 10.0.2.0/24, eu-west-2b
├── Private app subnet A: 10.0.11.0/24, eu-west-2a
└── Private app subnet B: 10.0.12.0/24, eu-west-2b
```

The two public subnets are separate address pools. The two private app subnets are also separate address pools.

### 4.4 How AWS assigns private IPs

When you launch an EC2 instance into a subnet, AWS creates or uses a network interface and assigns a free private IP from that subnet. The same broad idea applies to other resources that need a network interface, including Fargate tasks and ALB nodes.

Example:

```text
Subnet: 10.0.1.0/24
├── ALB network interface: 10.0.1.20
├── EC2 network interface: 10.0.1.21
├── another resource:     10.0.1.22
└── remaining addresses:  available capacity
```

The addresses are not allocated one per visitor or one per HTTP request. Requests reuse the service’s network interfaces and connections.

### 4.5 Public subnet

A subnet is considered public when its associated route table has a route to an Internet Gateway, commonly:

```text
0.0.0.0/0 → Internet Gateway
```

For an IPv4 EC2 instance to communicate directly with the internet, it also needs a public IPv4 address or Elastic IP. A route to an Internet Gateway alone does not automatically give every instance a public IP.

### 4.6 Private subnet

A private subnet does not have a direct route to an Internet Gateway. Resources in it are not directly reachable from the public internet through IPv4.

Private resources may still need outbound access:

```text
Private subnet → NAT Gateway in public subnet → Internet Gateway → internet
```

The NAT Gateway allows outbound connections initiated by private resources. It does not make those private resources directly reachable from the internet.

For AWS service access, VPC endpoints can sometimes avoid NAT:

```text
Private task → VPC endpoint → ECR / S3 / CloudWatch / other supported service
```

### 4.7 Public and private IP addresses on EC2

Every EC2 network interface has a private IPv4 address. A public IPv4 address is assigned only when public-IP auto-assignment is enabled or an Elastic IP is associated.

So the accurate rule is:

```text
Private IP → always required for VPC networking
Public IP  → conditional; depends on subnet setting or Elastic IP
```

In many default-subnet or launch-wizard scenarios, public-IP assignment is enabled, which is why it can look automatic. Do not assume it for every custom subnet or production design.

### 4.8 Route table

A route table decides where packets should go next. A subnet is associated with a route table.

Typical routes:

| Destination | Target | Meaning |
| --- | --- | --- |
| VPC CIDR | `local` | Resources in the VPC can communicate according to security controls |
| `0.0.0.0/0` | Internet Gateway | Public internet route |
| `0.0.0.0/0` | NAT Gateway | Private subnet outbound internet route |
| Other network CIDR | Transit Gateway, VPN, peering, or endpoint | Route to another private network |

Routing answers “where should this packet go?” It does not by itself grant permission. Security Groups and NACLs still apply.

### 4.9 Internet Gateway

An Internet Gateway attaches to a VPC and is the route-table target for internet-routable traffic. For IPv4, it also performs the logical one-to-one translation between a public address and the instance’s private address.

An Internet Gateway does not automatically:

- Give a subnet a route
- Give an instance a public IP
- Open a Security Group
- Make a private subnet public

All of those configuration pieces must line up.

### 4.10 NAT Gateway

A NAT Gateway provides outbound internet access for resources in private subnets. It is placed in a public subnet and normally uses an Elastic IP for IPv4 internet access.

Common production design:

```text
Private app subnet A → NAT Gateway A in public subnet A
Private app subnet B → NAT Gateway B in public subnet B
```

Using one NAT Gateway for multiple AZs may reduce cost but creates cross-AZ traffic and a dependency on one AZ. Using one per AZ improves resilience and can reduce cross-AZ data transfer, but costs more.

### 4.11 VPC endpoint

A VPC endpoint gives private resources a private path to supported AWS services. This can reduce NAT dependency and keep traffic inside AWS networking.

Examples you may meet in an ECS design:

- ECR API endpoint
- ECR Docker registry endpoint
- S3 Gateway endpoint
- CloudWatch Logs interface endpoint

The exact endpoint set depends on how the workload pulls images, sends logs, and calls AWS APIs.

---

## 5. Availability and network security

### 5.1 Multi-AZ design

For a resilient web application, spread the entry point and application capacity across at least two AZs:

```text
                    Region
          ┌───────────┴───────────┐
          ▼                       ▼
      AZ A                    AZ B
   public subnet            public subnet
       ALB node                ALB node
          │                       │
   private app subnet       private app subnet
       task/EC2                task/EC2
```

To make the pattern meaningful:

- The ALB must have enabled subnets in both AZs.
- There should be healthy targets in both AZs.
- The ECS service should place tasks across the available subnets.
- Route tables and Security Groups must work in both AZs.
- Shared dependencies must not create a single-AZ failure.

### 5.2 ALB subnet capacity

An Application Load Balancer requires at least two subnets from different AZs. AWS creates managed network interfaces in those subnets. The subnet is a pool from which the ALB can use addresses for nodes, scaling, and maintenance.

Current AWS guidance is:

- Use a subnet with at least a `/27` IPv4 CIDR for the ALB.
- Keep at least eight free IP addresses in each ALB subnet.

This does not mean the ALB permanently consumes every address. It means the subnet must retain capacity for managed operations.

Do not hardcode the ALB’s changing IP addresses. Use its DNS name or a Route 53 alias record.

### 5.3 Security Group

A Security Group is a virtual firewall attached to a resource’s network interface. It controls allowed inbound and outbound traffic.

Important properties:

- Security Groups contain allow rules; there is no explicit deny rule in a normal Security Group.
- They are stateful: return traffic for an allowed connection is automatically allowed.
- Rules can reference another Security Group instead of a changing IP address.
- A resource can have more than one Security Group; the effective result is the union of their allow rules.
- A rule must specify the protocol, port or range, and source or destination.

Example application chain:

```text
Internet
   │ TCP 443
   ▼
ALB Security Group
   │ TCP 8080 from ALB SG
   ▼
ECS task Security Group
   │ TCP 5432 from task SG
   ▼
RDS Security Group
```

The task Security Group should not normally allow the application port from `0.0.0.0/0`. It should allow the ALB Security Group as the source.

### 5.4 Security Group versus IAM

| Question | Security Group | IAM |
| --- | --- | --- |
| What does it control? | Network connections | AWS API actions and resource access |
| Example | Allow TCP 443 from the internet | Allow `s3:GetObject` on one bucket prefix |
| Attached to or used by | ENIs/resources | Users, groups, roles, services, policies |
| Direction | Inbound and outbound traffic | Allow or deny AWS actions through policy evaluation |
| Typical failure | Timeout or connection refused | `AccessDenied` |
| Main mental model | “Can this network endpoint connect?” | “Is this principal allowed to do this AWS action?” |

These can both block a request independently. A task may be reachable but receive `AccessDenied` from S3. A role may have correct S3 permissions while the task cannot reach the service because its route or Security Group is wrong.

### 5.5 Network ACL

A Network ACL is a subnet-level network filter.

| Feature | Security Group | Network ACL |
| --- | --- | --- |
| Scope | Network interface/resource | Subnet |
| Rule type | Allow only | Allow and deny |
| State | Stateful | Stateless; return traffic needs a rule |
| Rule evaluation | All applicable rules | Lowest numbered matching rule |
| Typical use | Primary workload access control | Additional subnet boundary control |

When a connection is mysteriously blocked, check NACL rules only after understanding the Security Groups and routes. NACLs can block ephemeral return ports even when the inbound rule looks correct.

### 5.6 Common network security mistakes

- Opening SSH (`22`) to `0.0.0.0/0`
- Opening database ports to the whole internet
- Assuming a public subnet automatically means every resource has a public IP
- Using IP-based rules between dynamic application tiers instead of Security Group references
- Forgetting outbound access for private ECS tasks to pull images or send logs
- Treating an Internet Gateway as a firewall
- Forgetting that a NACL is stateless
- Leaving a development ALB or EC2 public after moving the application to private subnets

---

## 6. IAM and AWS permissions

### 6.1 IAM in one sentence

IAM controls who or what can perform which AWS actions on which resources under which conditions.

### 6.2 IAM building blocks

- Principal: the identity making a request, such as a user, role, or AWS service.
- User: a long-lived identity for a person or legacy workload; prefer federation and roles where possible.
- Group: a collection of users; groups do not assume roles themselves.
- Role: an assumable identity that provides temporary credentials.
- Policy: JSON permission statements containing effects, actions, resources, and optional conditions.
- Trust policy: the role policy that says who may assume the role.
- Identity policy: permissions attached to a user, group, or role.
- Resource policy: a policy attached to a resource, such as an S3 bucket policy.

### 6.3 Trust policy versus permissions policy

These are often confused.

```text
Trust policy:
“Who is allowed to assume this role?”

Permissions policy:
“After the role is assumed, what may it do?”
```

A role is usable only when both sides work:

1. The principal is trusted to assume it.
2. The resulting role permissions allow the requested action.

### 6.4 Least privilege

Least privilege means granting only the permissions needed for the task, resource, and time period.

Prefer:

```text
Action: s3:GetObject
Resource: arn:aws:s3:::example-assets/images/*
```

over:

```text
Action: s3:*
Resource: *
```

Also consider conditions such as required tags, source VPC endpoints, encryption requirements, or a specific prefix.

### 6.5 Temporary credentials and roles

Do not hardcode permanent AWS access keys in application code, container images, AMIs, repositories, or shell scripts.

Use roles so AWS can provide temporary credentials to the workload:

```text
EC2 instance profile → temporary credentials → AWS API
ECS task role        → temporary credentials → AWS API
```

Temporary credentials reduce the damage from accidental exposure and can expire automatically.

### 6.6 IAM roles in ECS

ECS commonly uses two different roles:

#### Task execution role

Used by the ECS/Fargate agent to perform platform actions such as:

- Pulling a private image from ECR
- Sending container logs to CloudWatch Logs
- Retrieving certain startup secrets, depending on configuration

#### Task role

Used by the application code inside the container to call AWS services.

Examples:

- Read objects from a specific S3 bucket
- Read a secret from Secrets Manager
- Publish an event to EventBridge
- Send messages to SQS

Do not put application permissions on the execution role just because it already exists. Give the application its own least-privilege task role.

### 6.7 IAM role in EC2

Attach an IAM role to EC2 through an instance profile. Software on the instance can then retrieve temporary credentials from the instance metadata service.

Example:

```text
EC2 instance
    ↓ instance profile
IAM role
    ↓ policy
CloudWatch / S3 / Secrets Manager access
```

### 6.8 IAM versus resource policies

For some services, access may depend on both identity and resource policies.

Example S3 request:

```text
Application task role
    ├── identity policy allows s3:GetObject
    └── S3 bucket policy does not deny it
                 ↓
             object access
```

A broad identity policy does not guarantee access if a bucket policy, permissions boundary, SCP, VPC endpoint policy, or explicit deny blocks the request.

### 6.9 IAM troubleshooting questions

When you see `AccessDenied`, ask:

1. Which principal made the request?
2. Which role or credentials were actually used?
3. Is the action spelled correctly?
4. Does the resource ARN match the Region, account, bucket, key, or path?
5. Is there an explicit deny?
6. Is a permissions boundary or Organizations SCP limiting the role?
7. Does the resource policy allow the principal?
8. Is the workload reaching the correct AWS endpoint?
9. Is the application using the task role or accidentally using another credential source?

---
## 7. Amazon EC2

### 7.1 What EC2 is

Amazon Elastic Compute Cloud (EC2) gives you virtual machines in AWS. You choose the operating-system image, compute size, storage, network placement, and access controls.

An EC2 instance is not the same thing as a container:

```text
EC2 instance
├── guest operating system
├── installed packages
├── application processes
├── network interfaces
└── attached storage
```

You are responsible for more of the operating system and host configuration than with Fargate.

### 7.2 AMI

AMI means Amazon Machine Image. It is the boot template for an EC2 instance.

An AMI can contain:

- Linux or Windows operating system
- Root volume configuration
- Preinstalled packages
- Security hardening
- Application setup
- Custom configuration captured from an existing server

Example mental model:

```text
AMI → creates the starting disk and operating system
Instance type → chooses CPU, memory, network, and instance capacity
```

AMI IDs are Region-specific. An AMI that exists in `eu-west-2` may not exist under the same ID in `us-east-1`.

### 7.3 Instance type

An instance type describes the virtual hardware allocation. It affects:

- vCPUs
- Memory
- Network performance
- EBS bandwidth
- Local or ephemeral storage on some families
- Architecture such as x86_64 or ARM64
- Price

Choosing an instance type is a capacity decision. Start with the workload requirements and measure CPU, memory, network, and disk pressure rather than choosing only by habit.

### 7.4 EC2 networking

An EC2 instance has a primary network interface in a subnet. It receives a private IP from that subnet. It may also receive a public IPv4 address or Elastic IP.

Typical communication:

```text
Client inside VPC → EC2 private IP
Internet client → EC2 public IP or Elastic IP → EC2 private IP
```

Do not use a public IP for internal service-to-service communication. Use private addresses, private DNS, or a load balancer.

### 7.5 EBS volumes

Elastic Block Store (EBS) provides block storage for EC2. The root volume normally contains the operating system.

Important properties:

- EBS volumes are normally tied to one AZ.
- You choose volume type, size, and performance characteristics.
- Snapshots are stored separately and can be used for backup or new volumes.
- Deleting an instance does not always have the same effect on every volume; check the delete-on-termination setting.
- A disk being attached does not mean the filesystem is mounted or healthy inside Linux.

Use EBS for an EC2 server’s operating system and block-level application storage. Use S3 for object storage and shared durable files.

### 7.6 Key pairs and administration

An EC2 key pair is commonly used for SSH access to Linux instances. The private key must be protected, and the Security Group should restrict SSH to trusted source addresses or a controlled management path.

For production, consider Systems Manager Session Manager so you can administer instances without exposing SSH to the internet. The instance needs the appropriate IAM role, SSM agent support, and network access to the Systems Manager endpoints.

### 7.7 User data

EC2 user data is startup input often used to install packages or configure the instance on first boot. It can be useful for repeatable bootstrapping, but it is not a complete configuration-management or deployment strategy by itself.

Check:

- Whether the script runs on first boot or every boot for the chosen mechanism
- Shell errors and ordering
- Package repository availability
- IAM and network access
- Logs such as `/var/log/cloud-init-output.log` on common Linux images

### 7.8 Public IPv4 versus Elastic IP

An automatically assigned public IPv4 address can change when the instance is stopped and started. An Elastic IP is a persistent public IPv4 address allocated to your account and associated with a resource.

Prefer a load balancer or DNS name for application access. Use an Elastic IP only when the design truly needs a stable public address, because unused allocated public addresses may cost money and direct instance exposure increases security responsibility.

### 7.9 EC2 lifecycle

Common states:

- Pending: AWS is starting the instance.
- Running: the instance is active and billed for compute.
- Stopping: AWS is shutting it down.
- Stopped: compute is not running, but storage and other resources may still incur charges.
- Terminated: the instance is deleted and normally cannot be restarted.

Stopping is not the same as terminating. Always confirm the action before deleting an instance.

### 7.10 EC2 health checks

EC2 system status checks usually detect problems with the underlying host or AWS infrastructure. Instance status checks look at the instance operating system and networking. A failed check is evidence to investigate, not an automatic explanation of the application failure.

Check the instance console output, system logs, disk space, memory, processes, routes, and Security Groups.

---

## 8. Auto Scaling Groups

### 8.1 What an Auto Scaling Group does

An EC2 Auto Scaling Group (ASG) maintains a desired number of EC2 instances. It can launch replacements when instances fail and add or remove capacity based on policies.

The key settings are:

- Minimum capacity: the lowest number of instances the group should maintain
- Desired capacity: the target number currently requested
- Maximum capacity: the upper limit for scaling

Example:

```text
min = 2
desired = 2
max = 6
```

The group tries to keep two instances running initially and may scale up to six when policy conditions require it.

### 8.2 Launch template

A launch template describes how new EC2 instances should be created:

- AMI
- Instance type
- Security Groups
- IAM instance profile
- Storage mappings
- User data
- Network settings
- Tags

An ASG uses the template to create consistent replacement instances.

### 8.3 ASG and load balancer relationship

The common web pattern is:

```text
ALB target group
        ↓ health checks
Auto Scaling Group
        ↓ maintains instances
EC2 instances
```

If an instance fails the target group health check or the ASG health check, the group can remove it and launch a replacement. Make sure the health check tests the real application path, not just a port that is open but useless.

### 8.4 Scaling policies

Common approaches:

- Target tracking: keep a metric near a target, such as average CPU.
- Step scaling: add or remove different amounts based on alarm ranges.
- Scheduled scaling: change capacity at known times.

Scaling is not a substitute for fixing slow code, database bottlenecks, memory leaks, or incorrect health checks.

### 8.5 What ASG scaling changes

An ASG changes the number of EC2 instances. It does not directly change the number of containers or ECS tasks running on those instances.

```text
ASG → number of EC2 instances
ECS Service Auto Scaling → number of ECS tasks
```

With ECS on EC2, both layers may matter. With Fargate, you normally scale tasks without managing EC2 instances.

---

## 9. Containers, ECR, and ECS

### 9.1 Container image

A container image is a packaged filesystem and metadata for running an application. It usually contains the application, runtime, libraries, and startup command.

The image is immutable after it is built. Configuration such as environment-specific secrets should normally be injected at runtime rather than baked into the image.

### 9.2 Amazon ECR

Amazon Elastic Container Registry (ECR) is AWS’s managed container registry. A repository stores image manifests and layers.

```text
ECR repository: mobile-api
├── image tag: 1.0.0
├── image tag: 1.1.0
└── image digest: sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

Important ideas:

- A tag is a human-friendly label and can be moved.
- A digest identifies the exact image content.
- `latest` is convenient for experiments but weak for controlled production rollbacks.
- Image scanning helps identify known vulnerabilities but does not prove an image is safe.
- Lifecycle policies can remove old unneeded images and control storage cost.
- Private ECR access requires the workload’s platform permissions, network path, and repository access to all work.

### 9.3 ECS in one sentence

Amazon Elastic Container Service (ECS) schedules and maintains containers as tasks in a cluster.

ECS is an orchestrator. It is not itself the compute capacity; Fargate or EC2 supplies the capacity.

### 9.4 ECS cluster

An ECS cluster is a logical grouping for tasks and services. It is an organisational boundary for scheduling and observing workloads.

The cluster does not automatically provide:

- A public IP
- A load balancer
- An image repository
- A database
- Internet connectivity

Those are separate resources that must be configured.

### 9.5 Task definition

A task definition is the blueprint for running one or more containers together.

Common task-definition settings:

- Container image
- Container name
- CPU and memory
- Port mappings
- Environment variables
- Secrets references
- Health checks
- Logging configuration
- Volumes
- Task execution role
- Task role
- Fargate platform and architecture settings

Example conceptually:

```text
Task definition: api:12
├── image: 123456789012.dkr.ecr.eu-west-2.amazonaws.com/api@sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
├── container port: 8080
├── CPU: 0.5 vCPU
├── memory: 1 GB
├── logs: /ecs/api
├── execution role: ECSTaskExecutionRole
└── task role: ApiTaskRole
```

Creating a new task-definition revision does not automatically replace running tasks. A service deployment must use the new revision.

### 9.6 Task

A task is a running instantiation of a task definition. If the task definition says how a container should run, the task is one actual running copy.

```text
Task definition revision 12
    ├── Task A
    ├── Task B
    └── Task C
```

With Fargate `awsvpc` networking, each task receives its own elastic network interface and private IP address in a selected subnet.

### 9.7 ECS service

An ECS service maintains a desired number of tasks and replaces tasks that fail or stop. It can integrate with a load balancer, deployments, health checks, and service auto scaling.

Example:

```text
desired count = 2
running tasks = 2
```

If one task crashes and the service can place another task, ECS attempts to return to the desired count.

### 9.8 Service desired count

Desired count is the number of task copies the service should try to keep running. It is not a promise that all tasks are currently healthy.

Always compare:

- Desired count
- Running count
- Pending count
- Deployment count
- Healthy target count

A service can report desired count 2 while both tasks are failing health checks or stuck pending.

### 9.9 ECS on EC2 versus ECS on Fargate

| Decision | ECS on EC2 | ECS on Fargate |
| --- | --- | --- |
| Compute | Your EC2 instances | AWS-managed task compute |
| Host OS work | You patch and manage instances | AWS manages the underlying host boundary |
| Capacity planning | Choose and scale instance fleet | Choose task CPU and memory |
| Density | Pack multiple tasks on instances | Task-level allocation managed by AWS |
| Control | More host-level control | Less host-level control |
| Operational work | More infrastructure responsibility | Less infrastructure responsibility |
| Useful when | Special host needs, cost optimisation at scale, custom agents | Simpler container operations and task-level isolation |

The container image and ECS concepts are similar. The compute responsibility changes.

### 9.10 Fargate networking

Fargate tasks using `awsvpc` receive an ENI. You select subnets and Security Groups for the task network interface.

Private task pattern:

```text
ALB public subnet
        ↓ allowed by task SG
Fargate task private subnet
        ↓ outbound through NAT or VPC endpoints
ECR / CloudWatch / other AWS services
```

If a private task pulls an image from ECR or sends logs to CloudWatch, it needs the required execution role and a working network path. The task does not become public just because the ALB is public.

### 9.11 ECS capacity and scaling

There are separate scaling dimensions:

```text
Service Auto Scaling → task count
ASG                   → EC2 instance count for ECS on EC2
```

If the service wants more tasks but no capacity exists on ECS EC2 instances, tasks may remain pending. Fargate removes the EC2 capacity-fleet layer but still has quotas, subnet IP capacity, CPU/memory limits, and service limits.

### 9.12 ECS and load balancer port mapping

The request path must match at every layer:

```text
ALB listener 443
    ↓ forwarding rule
Target group port 8080
    ↓ task mapping
Container port 8080
    ↓ process
Application listening on 0.0.0.0:8080
```

An application listening only on `127.0.0.1` inside a container may not be reachable through the task network interface. Web applications should normally bind to `0.0.0.0` inside the container when they are meant to receive external task traffic.

### 9.13 ECS health checks

Health can be checked at multiple levels:

- Container health check
- ECS task state
- ALB target health check
- Application readiness and dependency checks
- Service deployment health

A port-open check can pass while the application is broken. A useful health endpoint should return failure when the service cannot perform its required function, while avoiding unnecessary dependency coupling that makes a temporary downstream issue remove every task.

### 9.14 ECS deployment basics

An ECS service deployment commonly:

1. Registers a new task-definition revision.
2. Starts new tasks with the revision.
3. Waits for container and target health.
4. Shifts traffic through the target group.
5. Stops old tasks after the deployment is healthy.

If new tasks fail health checks, inspect the task stopped reason, container logs, environment variables, image architecture, role permissions, target group port, and Security Groups.

---

## 10. Application Load Balancer

### 10.1 What an ALB does

An Application Load Balancer is a managed Layer 7 load balancer for HTTP and HTTPS applications. It accepts client connections and routes requests to healthy targets.

Typical target types include:

- IP addresses, commonly used for Fargate tasks
- EC2 instances
- Lambda functions in supported patterns

### 10.2 ALB components

```text
Client
  ↓
Listener: protocol and port, such as HTTPS 443
  ↓
Listener rule: host/path/action conditions
  ↓
Target group: targets, port, protocol, health check
  ↓
Healthy target: EC2 instance or task IP
```

#### Listener

The listener waits on a port and protocol. It can terminate TLS for HTTPS and apply rules.

#### Listener rule

Rules can route by host header or path, for example:

```text
api.example.com/*      → API target group
example.com/images/*   → static target group or redirect
example.com/admin/*    → admin target group
```

#### Target group

A target group defines where traffic goes, which port is used, and how health is checked.

#### Health check

The ALB periodically sends a request to a target path and expects an allowed response. Unhealthy targets are removed from normal routing.

### 10.3 Why an ALB requires two AZs

For an Application Load Balancer, you select at least two subnets from different AZs. AWS creates a managed ALB node in each enabled AZ.

This gives the ALB a path to continue serving traffic if one AZ becomes unavailable or has no healthy targets. A truly resilient application should also have application targets in more than one AZ.

### 10.4 ALB IP addresses

The subnets provide address capacity to the ALB; they do not hand the entire CIDR block to it. The ALB uses managed network interfaces and can need additional addresses during scaling or maintenance.

Use:

```text
Route 53 alias → ALB DNS name
```

Do not build an application around a specific ALB node IP. The set of IPs can change.

### 10.5 Internet-facing versus internal ALB

- Internet-facing ALB: has a public-facing entry point and normally sits in public subnets.
- Internal ALB: reachable through private networking and normally used inside a VPC or connected network.

The targets behind an internet-facing ALB can still be private. Public entry and private workloads are often the safer design.

### 10.6 TLS termination

With HTTPS termination at the ALB:

```text
Client --HTTPS 443--> ALB --HTTP or HTTPS--> target
```

The ALB uses an ACM certificate. Whether traffic from ALB to target is HTTP or HTTPS depends on the security and compliance requirements of the design.

If encryption must remain end-to-end, use HTTPS between the ALB and target as well and configure target certificates correctly.

### 10.7 ALB versus Network Load Balancer

| Feature | ALB | NLB |
| --- | --- | --- |
| Main layer | HTTP/HTTPS application routing | Transport-level TCP/UDP/TLS routing |
| Routing | Host and path rules | Connection and network flow based |
| Typical use | Web apps, APIs, microservices | Very high performance, static IP needs, non-HTTP protocols |
| Target health | Application-aware options | Network/transport-oriented options |
| Fixed IP behaviour | Do not rely on node IPs | Supports patterns requiring static IPs more directly |

Choose the load balancer based on the protocol and routing requirement, not just on the word “load balancing.”

### 10.8 ALB failure checklist

If a request does not reach an ECS or EC2 application, check in this order:

1. DNS resolves to the expected ALB or CloudFront name.
2. The ALB is active and has subnets in at least two AZs.
3. The listener exists on the port and protocol the client uses.
4. The listener rule matches the host/path.
5. The target group contains the expected targets.
6. Targets are healthy.
7. The ALB Security Group allows client traffic.
8. The target Security Group allows traffic from the ALB Security Group on the target port.
9. The process is listening on the target port and correct bind address.
10. Application logs explain any 4xx or 5xx response.

### 10.9 ALB status-code clues

- 4xx from the ALB often suggests a client request, listener rule, authentication, or routing issue.
- 502 often suggests the ALB could not establish a valid connection to the target or the target returned an invalid response.
- 503 often suggests no healthy targets or a listener/routing condition with no available target.
- 504 often suggests a timeout waiting for the target.

Always confirm using target health reasons and logs; do not treat a status code as a complete diagnosis.

---

## 11. Amazon Route 53 and DNS

### 11.1 What Route 53 does

Amazon Route 53 is AWS’s DNS and domain-routing service. It can host DNS zones, register domains through the service, perform health checks, and route names to AWS resources or external endpoints.

### 11.2 Hosted zone

A hosted zone contains DNS records for a domain.

- Public hosted zone: answers public internet DNS queries.
- Private hosted zone: answers queries from associated VPCs.

### 11.3 Common DNS records

| Record | Purpose |
| --- | --- |
| A | Maps a name to an IPv4 address |
| AAAA | Maps a name to an IPv6 address |
| CNAME | Maps a name to another name; not normally used at the zone apex |
| Alias | AWS-specific routing to supported AWS resources, including ALB and CloudFront |
| MX | Mail delivery servers |
| TXT | Verification and text data |
| NS | Name servers for a zone |
| SOA | Start-of-authority metadata |

For an ALB or CloudFront distribution, use a Route 53 alias where supported instead of hardcoding changing IP addresses.

### 11.4 TTL

TTL tells resolvers how long they may cache a DNS answer. Lower TTL can make changes visible sooner but creates more DNS queries. Higher TTL can reduce lookup traffic but makes changes slower to propagate from cached resolvers.

DNS changes are not always instantly visible everywhere because caches may still honour the old TTL.

### 11.5 Route 53 application patterns

```text
api.example.com → ALB alias
www.example.com → CloudFront alias
assets.example.com → CloudFront distribution for S3
internal-api.example.local → internal ALB through private hosted zone
```

### 11.6 DNS health and routing policies

Route 53 supports routing policies such as simple, weighted, latency-based, failover, geolocation, and geoproximity patterns. Use them when the application actually needs traffic steering or failover; a simple alias is easier to operate when it is sufficient.

### 11.7 DNS troubleshooting

Check:

1. The client is querying the expected resolver.
2. The authoritative name servers are correct at the registrar.
3. The hosted zone contains the intended record.
4. The record type matches the destination.
5. The alias points to the correct Region/resource.
6. The result is cached because of TTL.
7. The returned endpoint is reachable on the expected port.

Commands:

```bash
dig +short example.com
dig example.com NS
dig example.com A
nslookup example.com
```

---

## 12. CloudFront

### 12.1 What CloudFront is

Amazon CloudFront is AWS’s content delivery network. It delivers cached or proxied content from edge locations closer to viewers than the origin may be.

CloudFront is not the web server. It receives viewer requests, checks cache and distribution rules, and uses an origin when it needs to retrieve content.

### 12.2 Origin

An origin is the source CloudFront contacts when it does not have a valid cached response.

Common origins:

- S3 bucket
- Application Load Balancer
- Network Load Balancer
- EC2 or another HTTP server
- API Gateway
- Lambda function URL

### 12.3 Distribution and cache behaviour

A distribution is the CloudFront configuration. Cache behaviours decide how requests are handled, often based on a path pattern.

Example:

```text
/assets/* → S3 origin, long cache lifetime
/api/*    → ALB origin, usually no caching or short caching
default   → application origin
```

CloudFront cache decisions can depend on the path, query strings, headers, cookies, and allowed methods. Adding unnecessary values to the cache key reduces cache hits.

### 12.4 Cache hit and miss

```text
Viewer request
      ↓
CloudFront edge location
      ├── cache hit  → return cached object
      └── cache miss → request object from origin, then cache if allowed
```

A cache hit reduces origin traffic and latency. A cache miss requires an origin request. Dynamic requests and methods such as `POST` generally go to the origin rather than being served as a cached object.

### 12.5 TTL and invalidation

TTL controls how long an object can remain cached. If an object is changed at the origin, viewers may continue to receive the old version until the TTL expires.

Options:

- Use versioned filenames such as `app.2026-09-27.js` for static assets.
- Use a CloudFront invalidation when you need to remove cached paths before normal expiry.
- Set cache policies deliberately for APIs and user-specific content.

Do not cache private or user-specific responses without understanding the cache key and forwarding behaviour.

### 12.6 CloudFront with S3

Recommended pattern for private S3 content:

```text
Viewer → CloudFront → S3 bucket
                   ↑
          Origin Access Control
```

Origin Access Control allows the bucket to remain private while CloudFront retrieves objects through an authenticated integration. Avoid making the whole bucket public simply to make CloudFront work.

### 12.7 CloudFront with ALB

Common web architecture:

```text
Viewer → Route 53 → CloudFront → ALB → ECS or EC2
```

CloudFront can provide edge TLS, caching, geographic delivery, and integration with WAF. The ALB still performs application-level routing to healthy targets.

### 12.8 CloudFront and security

Useful controls include:

- HTTPS viewer connections
- ACM certificate for the CloudFront alternate domain
- AWS WAF web ACL
- Origin Access Control for S3
- Restrictions preventing direct origin access where appropriate
- Signed URLs or signed cookies for private content
- Logging and monitoring

CloudFront and WAF improve the edge layer; they do not replace correct IAM, Security Groups, secure application code, or private subnet design.

### 12.9 CloudFront troubleshooting

Check:

1. DNS points to the intended distribution.
2. The alternate domain and certificate match.
3. The path matches the expected cache behaviour.
4. The method is allowed.
5. The cache policy forwards required headers, cookies, and query strings.
6. The origin is reachable and its certificate/host header settings are correct.
7. S3 permissions allow CloudFront through OAC.
8. The response is stale because of TTL.
9. WAF rules are not blocking the request.
10. CloudFront and origin logs show where the request stops.

---

## 13. Storage services you will use with these architectures

### 13.1 S3

Amazon Simple Storage Service (S3) stores objects in buckets.

```text
Bucket: app-assets
└── object key: images/logo.png
```

S3 concepts:

- Bucket: the container with a globally unique name.
- Object: data plus metadata.
- Key: the object’s name, often written like a path.
- Region: where the bucket is hosted.
- Versioning: retains previous object versions.
- Lifecycle rules: transition or expire objects.
- Bucket policy: resource-based permissions.
- Encryption: server-side encryption options, including AWS-managed or customer-managed KMS keys.
- Storage class: cost and retrieval tradeoffs.

Common use cases:

- Static assets
- Uploads
- Backups
- Logs and exported data
- Build or data artifacts

Default-safe principles:

- Keep Block Public Access enabled unless public access is explicitly required and understood.
- Use least-privilege bucket policies.
- Use CloudFront OAC for private content delivered through CloudFront.
- Enable versioning when recovery from accidental overwrite or deletion matters.
- Set lifecycle rules for old versions and incomplete uploads.

### 13.2 EBS

EBS is block storage attached to EC2. The operating system sees a block device that can be formatted and mounted.

Use EBS for:

- EC2 root volumes
- Databases on EC2 when appropriate
- Filesystems requiring block storage

EBS is not a shared object store and is not automatically multi-AZ.

### 13.3 EFS

Amazon Elastic File System (EFS) is a managed shared file system that can be mounted by multiple compute resources through network interfaces.

Use EFS when multiple tasks or instances need shared POSIX-style filesystem access. Understand throughput, performance mode, mount-target networking, and Security Groups before using it as a default.

### 13.4 RDS

Amazon Relational Database Service (RDS) manages relational databases such as PostgreSQL and MySQL.

Common production pattern:

```text
ALB → ECS tasks in private subnets → RDS in private database subnets
```

The database Security Group should allow the database port only from the application Security Group, not from the whole internet.

Important distinctions:

- Multi-AZ is primarily for availability and failover.
- Read replicas are primarily for read scaling and replication use cases.
- Backups and snapshots support recovery but must be tested.
- A database is still an application dependency; monitor connections, storage, CPU, memory, latency, and failovers.

### 13.5 Storage decision table

| Need | Good starting service | Why |
| --- | --- | --- |
| EC2 operating system disk | EBS | Block storage attached to an instance |
| Images, videos, uploads, backups | S3 | Durable object storage and lifecycle controls |
| Shared filesystem across tasks | EFS | Network file system accessible by multiple clients |
| Relational queries and transactions | RDS | Managed relational database |
| Container image storage | ECR | Managed container registry |

---

## 14. HTTPS, certificates, WAF, and Shield

### 14.1 ACM

AWS Certificate Manager (ACM) issues and manages TLS certificates for supported AWS services.

Common placements:

- CloudFront certificate: use the required CloudFront certificate Region rules.
- Regional ALB certificate: request or import it in the ALB’s Region.

A certificate proves the domain identity and enables encrypted TLS. It does not configure DNS, open ports, or make the application healthy.

### 14.2 HTTPS flow

```text
Client
  ↓ TLS handshake and certificate verification
CloudFront or ALB
  ↓ request forwarding
Application target
```

Common errors:

- Domain name is not covered by the certificate.
- Certificate is in the wrong Region for a regional service.
- DNS points to a different endpoint.
- Listener exists only on HTTP, not HTTPS.
- Backend HTTPS certificate or trust configuration is wrong.

### 14.3 AWS WAF

AWS WAF filters HTTP requests using rules attached to supported services such as CloudFront or an ALB.

Use it for controls such as:

- Managed rule groups
- IP allow or block lists
- Rate-based rules
- Request-size and pattern restrictions
- Geographic restrictions where appropriate

WAF is an HTTP request filter. It is not a replacement for Security Groups, IAM, TLS, authentication, or secure application code.

### 14.4 AWS Shield

AWS Shield helps protect against distributed denial-of-service attacks. The level of protection and operational support depends on the service and the Shield offering.

WAF and Shield are edge protections. Continue to design for capacity, caching, rate limits, healthy dependencies, and safe failure.

---

## 15. Monitoring, logging, alerting, and tracing

### 15.1 CloudWatch overview

Amazon CloudWatch is the main AWS observability platform for your application architecture.

It provides:

- Metrics: numeric measurements over time
- Logs: event and application text
- Dashboards: visual views of important signals
- Alarms: state changes when a metric crosses a condition
- Events and rules: responses to service events
- Application Signals and related tracing integrations for service behaviour

### 15.2 Logs

CloudWatch Logs stores log events in log groups and log streams.

Typical log groups:

```text
/ecs/mobile-api
/aws/lambda/example-function
/aws/elasticloadbalancing/eu-west-2/123456789012/app.example
```

For ECS, configure the task definition’s log driver so container stdout and stderr reach the intended log group.

Good log practices:

- Use structured JSON where practical.
- Include request IDs or correlation IDs.
- Log useful context without logging secrets or unnecessary personal data.
- Set retention rather than keeping everything forever by accident.
- Make timestamps and severity clear.
- Check both application and platform logs.

### 15.3 Metrics

Metrics are numbers such as CPU percentage, request count, latency, or healthy target count. A metric’s dimensions identify the resource or series.

Useful signals for the architecture you designed:

#### ALB

- Request count
- HTTP 4xx count
- HTTP 5xx count
- Target 4xx and 5xx count
- Target response time
- Healthy host count
- Unhealthy host count

#### ECS

- CPU utilisation
- Memory utilisation
- Running task count
- Desired task count
- Pending task count
- Deployment failures
- Container restarts or stopped-task reasons

#### EC2

- CPU utilisation
- Status checks
- Network traffic
- EBS volume throughput, IOPS, and queue depth where relevant
- Disk and memory from an installed agent when needed

#### RDS

- CPU and memory pressure
- Database connections
- Free storage
- Read/write latency
- Replica lag where relevant

### 15.4 Dashboards

A useful dashboard follows the request path instead of displaying every metric available.

Suggested panels:

```text
Availability: healthy targets, running tasks, status checks
Traffic: request count, throughput, 4xx, 5xx
Latency: target response time, p95 or p99 if available
Capacity: ECS CPU/memory, task count, EC2 capacity
Dependencies: database connections, errors, queue depth
Logs/traces: links to the relevant log groups and trace views
```

### 15.5 Alarms

An alarm evaluates a metric against a condition and enters a state:

- OK
- ALARM
- INSUFFICIENT_DATA

Example alarm ideas:

```text
ALB 5xx errors above a meaningful threshold
Unhealthy targets above zero for a sustained period
ECS running tasks below desired tasks
ECS memory or CPU sustained above capacity target
API latency above the user-impact threshold
RDS free storage below a safe level
```

Avoid alerting on every small fluctuation. An alarm should represent a condition that needs investigation or action.

### 15.6 SNS

Amazon Simple Notification Service (SNS) distributes messages to subscribers.

Common flow:

```text
CloudWatch alarm → SNS topic → email, HTTPS endpoint, incident platform, or Lambda
```

CloudWatch can detect and trigger. SNS delivers the message. A human or downstream system still needs a useful response process.

### 15.7 CloudWatch versus CloudTrail

| Service | Main question |
| --- | --- |
| CloudWatch | Is the workload healthy and what is it doing? |
| CloudTrail | Which AWS API action happened, by whom, and when? |

CloudWatch is operational monitoring. CloudTrail is API activity and audit evidence.

### 15.8 VPC Flow Logs

VPC Flow Logs provide metadata about accepted and rejected network traffic for VPC, subnet, or network-interface scopes, depending on configuration.

They do not replace packet capture or application logs, but they help answer:

- Did traffic reach the network interface?
- Was it accepted or rejected?
- Which source and destination addresses and ports were involved?

### 15.9 Tracing and Application Signals

Metrics tell you that latency is high. Logs may show an error. Distributed tracing helps show where a request spent time across services.

For a production application, consider:

- AWS X-Ray or OpenTelemetry-compatible tracing
- Correlation IDs in application logs
- Service-level latency and error indicators
- Dependency maps and traces

Use tracing to connect a user request to the ALB, ECS task, database, and external dependency when the architecture is large enough to justify it.

---
## 16. The complete production architecture

This is the reusable pattern that joins the AWS module together for a web application, API, or mobile backend.

### 16.1 High-level request flow

```text
Mobile app or browser
        │ HTTPS
        ▼
Route 53
        │ DNS alias
        ▼
CloudFront distribution
        │ cache hit → response
        │ cache miss or dynamic request
        ▼
Internet-facing ALB in public subnets
        │ listener and rules
        ▼
ECS target group
        │ target health checks
        ▼
ECS service in private subnets
        │
        ├── Fargate task A in AZ A
        └── Fargate task B in AZ B
                │
                ├── RDS in private database subnets
                ├── S3 for object storage
                └── external/AWS services through approved routes
```

### 16.2 Supporting control and operations flow

```text
ECR repository ───────────────► ECS tasks pull image
IAM execution role ───────────► ECR and CloudWatch platform access
IAM task role ────────────────► application AWS API access
CloudWatch Logs ◄───────────── container stdout and stderr
CloudWatch Metrics ◄────────── ALB, ECS, EC2, RDS signals
CloudWatch Alarms ────────────► SNS topic
SNS topic ────────────────────► operators and incident systems
CloudTrail ◄────────────────── AWS API audit events
VPC Flow Logs ◄─────────────── network-flow evidence
```

### 16.3 Layer-by-layer design

| Layer | Typical AWS components | Main question |
| --- | --- | --- |
| Edge | Route 53, CloudFront, WAF, ACM | How do users find and securely reach the service? |
| Network | VPC, subnets, route tables, IGW, NAT, endpoints | Where can traffic travel? |
| Entry point | ALB, listeners, target groups | Which healthy application target receives the request? |
| Workload | ECS, Fargate, EC2, task definitions | What actually runs the application? |
| Image | ECR | Where does the exact container image come from? |
| Data | S3, EBS, EFS, RDS | Where is each kind of data stored? |
| Identity | IAM roles and policies | What may each person, service, or workload do? |
| Observability | CloudWatch, SNS, CloudTrail, Flow Logs | How do we know what happened and who is alerted? |

### 16.4 Why the application is private

The ALB is the public entry point. The ECS tasks do not need public IPs because the ALB reaches them over private VPC networking.

Benefits:

- Fewer directly exposed resources
- One controlled place for TLS and HTTP routing
- Security Group references between tiers
- Easier horizontal scaling and replacement
- Clear separation between user traffic and internal traffic

### 16.5 Request-by-request mental walkthrough

When a user opens `https://api.example.com/orders`, explain it like this:

1. The device resolves `api.example.com` through DNS.
2. DNS returns the CloudFront or ALB endpoint configured for that name.
3. The client establishes HTTPS with the edge or load-balancer endpoint.
4. CloudFront checks whether the request is cacheable and already cached.
5. If it needs the origin, CloudFront connects to the ALB.
6. The ALB listener receives the request on port 443.
7. Listener rules select the target group.
8. The ALB chooses a healthy ECS task.
9. The task’s Security Group allows traffic from the ALB Security Group.
10. The application process is listening on the mapped container port.
11. The application uses its task role if it needs S3, Secrets Manager, or another AWS API.
12. The response returns through the ALB and CloudFront to the client.
13. Logs and metrics are emitted to CloudWatch.
14. An alarm can publish an operational notification through SNS.

At any point, the request may stop. The troubleshooting method is to identify the exact boundary where it stopped.

---

## 17. Service choice quick reference

### 17.1 Which compute option?

| If you need… | Start with… | Reason |
| --- | --- | --- |
| A full virtual server and OS control | EC2 | You manage the machine and application |
| Containers without managing host capacity | ECS on Fargate | AWS manages the underlying task compute |
| Containers with host-level control or special capacity needs | ECS on EC2 | You manage the EC2 capacity fleet |
| A short event-driven function | Lambda | No server management for the function runtime |

### 17.2 Which entry point?

| Need | Start with… |
| --- | --- |
| HTTP/HTTPS host or path routing | ALB |
| TCP/UDP or very high-performance transport routing | NLB |
| Global caching and edge delivery | CloudFront |
| DNS name and routing policy | Route 53 |

CloudFront and ALB are complementary. CloudFront is the edge delivery layer; ALB is the application routing layer.

### 17.3 Which access control?

| Question | Tool |
| --- | --- |
| May this network connection reach the endpoint? | Security Group, route, NACL |
| May this principal call an AWS API? | IAM policy |
| May CloudFront retrieve a private S3 object? | S3 bucket policy plus CloudFront OAC |
| May an AWS service assume a role? | Role trust policy |
| Which AWS API call happened? | CloudTrail |

### 17.4 Which network placement?

| Resource | Common placement |
| --- | --- |
| Internet-facing ALB | Public subnets in at least two AZs |
| Internal ALB | Private subnets in multiple AZs |
| ECS tasks | Private subnets in multiple AZs |
| EC2 web fleet behind ALB | Private subnets in multiple AZs |
| NAT Gateway | Public subnet, ideally one per AZ for resilient private egress |
| RDS database | Private database subnets |
| S3 bucket | Regional managed service, not a VPC subnet |

### 17.5 Which storage?

| Data shape | Service |
| --- | --- |
| Bytes addressed by object key | S3 |
| Block device for one EC2 host | EBS |
| Shared filesystem mounted by multiple clients | EFS |
| Relational tables and transactions | RDS |
| Container image layers | ECR |

---

## 18. Read-only AWS CLI checks

These commands are useful for confirming reality during a job or project. Replace example values with the IDs and Region for your environment. They inspect state; they do not create or delete resources.

### 18.1 Confirm account and Region context

```bash
aws sts get-caller-identity
aws configure list
```

The first command tells you which account and principal your credentials use. The second helps confirm where the CLI is getting its configuration.

### 18.2 Inspect VPCs and subnets

```bash
aws ec2 describe-vpcs \
  --region eu-west-2 \
  --output table

aws ec2 describe-subnets \
  --region eu-west-2 \
  --filters Name=vpc-id,Values=vpc-0123456789abcdef0 \
  --query 'Subnets[].{Id:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock,FreeIPs:AvailableIpAddressCount,PublicIP:MapPublicIpOnLaunch}' \
  --output table
```

Use the output to verify the subnet’s AZ, CIDR, free capacity, and public-IP auto-assignment setting.

### 18.3 Inspect route tables

```bash
aws ec2 describe-route-tables \
  --region eu-west-2 \
  --filters Name=vpc-id,Values=vpc-0123456789abcdef0 \
  --query 'RouteTables[].{Id:RouteTableId,Routes:Routes,Associations:Associations}' \
  --output json
```

Look for the local route, an Internet Gateway route in public subnets, or a NAT Gateway route in private subnets.

### 18.4 Inspect EC2 instances and addresses

```bash
aws ec2 describe-instances \
  --region eu-west-2 \
  --instance-ids i-0123456789abcdef0 \
  --query 'Reservations[].Instances[].{State:State.Name,PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,Subnet:SubnetId,SGs:SecurityGroups[*].GroupId,AMI:ImageId,Type:InstanceType}' \
  --output table
```

### 18.5 Inspect Security Groups

```bash
aws ec2 describe-security-groups \
  --region eu-west-2 \
  --group-ids sg-0123456789abcdef0 \
  --output json
```

Confirm the source is the expected CIDR or Security Group, the protocol is correct, and the destination port matches the process.

### 18.6 Inspect ALB target health

```bash
aws elbv2 describe-target-health \
  --region eu-west-2 \
  --target-group-arn arn:aws:elasticloadbalancing:eu-west-2:123456789012:targetgroup/example/0123456789abcdef \
  --output table
```

The target health reason often tells you whether the problem is a timeout, failed response, wrong port, or a target that is not registered as expected.

### 18.7 Inspect ECS services and tasks

```bash
aws ecs describe-services \
  --region eu-west-2 \
  --cluster example-cluster \
  --services example-service \
  --query 'services[].{Desired:desiredCount,Running:runningCount,Pending:pendingCount,Deployments:deployments,Events:events[0:5]}' \
  --output json

aws ecs list-tasks \
  --region eu-west-2 \
  --cluster example-cluster \
  --service-name example-service \
  --desired-status RUNNING \
  --output table
```

For stopped tasks, inspect the task stopped reason and container exit code.

### 18.8 Read ECS logs

```bash
aws logs tail /ecs/example-service \
  --region eu-west-2 \
  --since 30m \
  --follow
```

Use the actual log group from the task definition. Do not assume the group name.

### 18.9 Inspect Route 53 records

```bash
aws route53 list-resource-record-sets \
  --hosted-zone-id Z0123456789ABCDEFG \
  --output table
```

The hosted-zone command does not take a Region because Route 53 hosted zones are global.

### 18.10 Inspect CloudWatch metrics

CloudWatch metric queries depend on the namespace, metric name, dimensions, period, and time window. Start in the console or use `list-metrics` to discover the exact dimensions before querying.

```bash
aws cloudwatch list-metrics \
  --region eu-west-2 \
  --namespace AWS/ApplicationELB \
  --metric-name HTTPCode_ELB_5XX_Count \
  --output table
```

### 18.11 CLI safety habits

- Confirm the account with `aws sts get-caller-identity`.
- Specify `--region` when investigating a regional resource.
- Prefer `--query` and `--output table` for focused inspection.
- Treat copied IDs and ARNs as untrusted until you verify account and Region.
- Read command help before using a write command.
- Avoid pasting secrets into shell history or chat.

---

## 19. Troubleshooting runbooks

### 19.1 The universal troubleshooting order

Use the narrowest evidence-based path instead of guessing:

1. Define the symptom precisely.
2. Identify the client, destination name, port, protocol, and time.
3. Confirm account, Region, and resource IDs.
4. Check DNS.
5. Check routes and subnet placement.
6. Check NACLs and Security Groups.
7. Check the listener and target group.
8. Check that the target is healthy and the process is listening.
9. Check IAM permissions for AWS API calls.
10. Check application logs, metrics, and traces.
11. Change one thing at a time.
12. Verify from the original client path.
13. Record the symptom, evidence, fix, and prevention.

### 19.2 “The website/API times out”

Likely layers:

- DNS returns the wrong endpoint
- Route table has no usable path
- Security Group or NACL blocks traffic
- ALB has no listener on the requested port
- ALB cannot reach the target
- The application is not listening
- The application is overloaded or stuck

Checks:

```bash
dig api.example.com
curl -v https://api.example.com/health
ss -lntp
```

Then inspect ALB target health and the ALB/task Security Groups.

### 19.3 “The Security Group allows the port but it still fails”

Remember that an allow rule is only one condition. Check:

- Does the client use the expected IP and port?
- Does the route table send traffic correctly?
- Does a NACL block the flow or return traffic?
- Is the target in the expected subnet?
- Is an application listening on that port?
- Is it listening on the correct interface?
- Is the ALB target group using the same port?

The apartment analogy applies: building security allowing door 80 does not guarantee a person is behind it.

### 19.4 “The ALB target is unhealthy”

Check:

1. Target group protocol and port.
2. Health-check path and expected response codes.
3. Target Security Group source: it should allow the ALB Security Group.
4. Container port mapping or EC2 application port.
5. Application bind address, commonly `0.0.0.0` for a container service.
6. Application startup time and health-check grace period.
7. Dependencies required by the health endpoint.
8. Target task or instance logs.
9. Whether the target is in a subnet with working routes.

### 19.5 “The ALB returns 502 or 503”

Start with target health. Then check:

- The target process is alive.
- The target port is correct.
- The target sends a valid HTTP response.
- The listener forwards to the intended target group.
- At least one target is healthy.
- The task did not exit after starting.
- The application is not closing connections or timing out.

### 19.6 “An ECS task keeps stopping”

Inspect the stopped-task reason and container exit code. Common causes:

- Image cannot be pulled from ECR
- Execution role lacks ECR or CloudWatch permissions
- Private subnet lacks NAT or required VPC endpoints
- Container command exits immediately
- Required environment variable or secret is missing
- CPU or memory is too small
- Wrong architecture image, such as ARM versus x86_64
- Container health check fails
- Application crashes during startup

### 19.7 “ECS task cannot pull from ECR”

Check all of these:

1. Image URI, repository, tag, or digest is correct.
2. Task execution role allows the required ECR actions.
3. The task has a route to ECR through NAT or appropriate VPC endpoints.
4. DNS resolution works in the VPC.
5. The Security Group permits required outbound traffic.
6. The image architecture matches the task architecture.
7. The repository is in the expected account and Region.

### 19.8 “The task can run but cannot read S3”

Separate network from IAM:

```text
Network path to S3 works?
        ↓
Task is using the intended task role?
        ↓
Task role allows s3:GetObject on the exact ARN?
        ↓
Bucket policy, endpoint policy, KMS policy, and explicit denies allow it?
```

If the error is `AccessDenied`, investigate IAM and resource policies. If the error is a timeout, investigate network routing and endpoints.

### 19.9 “The private task has no internet access”

Check:

- The subnet is actually private but has a route to a NAT Gateway if internet egress is needed.
- The NAT Gateway is in a public subnet.
- The public subnet route table points to an Internet Gateway.
- The NAT Gateway has a working Elastic IP path.
- NACLs allow outbound and return ephemeral traffic.
- Security Group outbound rules allow the connection.
- DNS works.
- The service can be accessed through a VPC endpoint instead of NAT where appropriate.

A private subnet is not “a subnet with no internet forever.” It is a subnet without a direct Internet Gateway route.

### 19.10 “The domain resolves but the site is old”

Likely causes:

- DNS resolver cache due to TTL
- CloudFront cache still contains an old object
- Browser cache
- Origin serves the old content
- Request path uses a different cache behaviour

Check headers, CloudFront cache status, origin content, and invalidate or version assets when appropriate.

### 19.11 “CloudWatch has no application logs”

Check:

- The container writes to stdout or stderr.
- The task definition has the expected log driver and log group.
- The task execution role can create streams and put log events.
- The log group exists in the correct Region.
- The task actually started and reached the logging stage.
- Retention and filtering settings are not hiding the events.

### 19.12 “The alarm is noisy or never fires”

Check:

- Metric namespace and dimensions identify the intended resource.
- Period and evaluation periods fit the event.
- The threshold represents user impact.
- Missing data treatment is deliberate.
- The alarm action points to the correct SNS topic.
- SNS subscriptions are confirmed and reachable.

### 19.13 Evidence table

| Evidence | What it helps prove |
| --- | --- |
| `dig` output | Which DNS answer the client receives |
| Route table | Where traffic is sent next |
| Security Group rules | Which network flows are allowed |
| NACL rules | Whether subnet-level stateless filtering blocks traffic |
| ALB target health | Whether the ALB can use a target |
| ECS stopped reason | Why a task stopped |
| Application logs | What the process experienced |
| CloudTrail event | Who made an AWS API change |
| VPC Flow Log | Whether a network flow was accepted or rejected |
| CloudWatch metric | Whether health, traffic, or capacity changed |

---

## 20. Production-readiness checklist

### 20.1 Network

- [ ] VPC CIDR is planned and does not overlap required connected networks.
- [ ] Workload subnets exist in at least two AZs when availability matters.
- [ ] Public subnets are limited to public entry or egress components.
- [ ] Application and database workloads are private where possible.
- [ ] Route tables are explicit and minimal.
- [ ] NAT or VPC endpoints provide only the outbound access actually needed.
- [ ] Subnet IP capacity is sufficient for tasks, ENIs, and scaling.
- [ ] ALB subnets meet the current capacity guidance.
- [ ] VPC Flow Logs are considered for important environments.

### 20.2 Security

- [ ] Root account has MFA and is not used for routine work.
- [ ] IAM roles are used for workloads instead of embedded access keys.
- [ ] Permissions follow least privilege.
- [ ] Task execution and task application roles are separated.
- [ ] Security Groups reference tiers rather than opening every port publicly.
- [ ] SSH and database ports are not open to the whole internet.
- [ ] Secrets are stored in a managed secrets system rather than images or source code.
- [ ] S3 Block Public Access and bucket policies are reviewed.
- [ ] HTTPS certificates are valid, renewed, and attached to the intended listener.
- [ ] WAF rules are appropriate for the actual application.
- [ ] CloudTrail and relevant audit logs are retained.

### 20.3 Availability and scaling

- [ ] Public entry points span at least two AZs.
- [ ] Healthy application capacity exists in more than one AZ.
- [ ] ECS desired count is greater than one where the service requires availability.
- [ ] Target health checks test application readiness.
- [ ] ECS deployment failure behaviour is understood.
- [ ] EC2 ASG min, desired, and max values are intentional where EC2 is used.
- [ ] Task CPU and memory have been observed under realistic load.
- [ ] Database backups and failover behaviour are understood.
- [ ] Recovery procedures have been tested rather than only documented.

### 20.4 Observability

- [ ] Application logs reach the correct CloudWatch log group.
- [ ] Log retention is intentional.
- [ ] ALB, ECS, EC2, database, and application metrics are visible.
- [ ] Dashboards show request rate, errors, latency, health, and capacity.
- [ ] Alarms represent actionable conditions.
- [ ] SNS subscriptions are confirmed.
- [ ] Correlation IDs or request IDs allow a request to be followed.
- [ ] CloudTrail and VPC Flow Logs are available when investigation needs them.

### 20.5 Cost

- [ ] Resources have project and environment tags.
- [ ] NAT Gateway count and traffic cost are understood.
- [ ] Idle public IPv4 and Elastic IP resources are reviewed.
- [ ] CloudWatch log retention is bounded.
- [ ] Old ECR images and S3 versions are managed with lifecycle rules.
- [ ] EC2 instance types and Fargate task sizes match observed demand.
- [ ] Budgets and cost anomaly alerts are considered.

---

## 21. Project build checklist

Use this when starting an AWS project from scratch.

### Step 1: Describe the workload

- What is the application?
- Is it a website, API, worker, mobile backend, batch job, or static site?
- Does it need a full operating system or can it run as a container?
- What data is persistent?
- Which users and regions matter?

### Step 2: Choose the compute path

- EC2 for host-level control or traditional server workloads.
- ECS on Fargate for containerised workloads without an EC2 fleet.
- ECS on EC2 when you need host control, special capacity, or dense packing.
- Lambda for discrete event-driven functions.

### Step 3: Draw the network before clicking

Write down:

```text
VPC CIDR
AZ A public subnet
AZ B public subnet
AZ A private app subnet
AZ B private app subnet
database subnet plan
route tables
Internet Gateway
NAT or VPC endpoints
Security Group relationships
```

### Step 4: Define exposure

List every public entry point. Ideally it is small and deliberate:

```text
Public: Route 53, CloudFront, internet-facing ALB
Private: ECS tasks, EC2 workers, internal ALB, RDS, internal services
```

### Step 5: Define identity

Create the roles and permissions before application debugging:

- Who deploys or administers?
- What does the platform need to start the workload?
- What does the application need at runtime?
- Which S3 objects, secrets, queues, or database systems are allowed?

### Step 6: Define health

Choose:

- Container health endpoint
- ALB target health path
- CloudWatch metrics
- Alarms and notification destinations
- Logs and retention
- Trace or correlation strategy

### Step 7: Test failure on purpose

Practice questions:

- What if one AZ loses capacity?
- What if one task stops?
- What if the image cannot be pulled?
- What if the database is unavailable?
- What if DNS is stale?
- What if the ALB has no healthy targets?
- What if the application role loses S3 access?
- What if logs stop arriving?

The quality of a production design is shown by how clearly it behaves when something fails.

---

## 22. Interview and on-the-job explanations

### “Why does an ALB need two Availability Zones?”

An Application Load Balancer requires subnets in at least two AZs so AWS can create load-balancer nodes in separate failure domains. If one AZ has an outage, the ALB can continue serving through the other AZ when healthy targets exist there. The subnets provide address capacity; the ALB does not consume the entire subnet CIDR.

### “What is a public subnet?”

A public subnet is associated with a route table that has a route to an Internet Gateway, typically `0.0.0.0/0`. A resource in it still needs a public IPv4 or Elastic IP for direct IPv4 internet communication. A route alone does not automatically assign a public address.

### “Why put ECS tasks in private subnets?”

The internet only needs to reach the ALB. The tasks can receive traffic privately from the ALB Security Group, which reduces direct exposure and centralises TLS and routing at the ALB. Private tasks still need a route through NAT or VPC endpoints for outbound AWS service access.

### “What is the difference between Security Groups and IAM?”

Security Groups control network traffic to and from resource interfaces. IAM controls whether a principal may call an AWS API or access a resource. A request can fail because either layer is wrong.

### “What happens when an ECS task dies?”

The ECS service sees that the running count is below the desired count and attempts to launch a replacement using the task definition. The replacement must have capacity, a valid image, working permissions, network access, and healthy application checks.

### “What is the difference between an ECS task definition and a task?”

A task definition is the versioned blueprint for the container configuration. A task is one running copy created from that blueprint.

### “What is the difference between ECS on EC2 and Fargate?”

Both run ECS tasks. ECS on EC2 requires you to manage the instance capacity fleet. Fargate provides task-level managed compute so you choose task CPU and memory without managing the underlying EC2 hosts.

### “What is CloudFront?”

CloudFront is AWS’s CDN. It receives viewer requests at edge locations, returns cached content when possible, and fetches cache misses from an origin such as S3 or an ALB. It is not the application server.

### “What does CloudWatch do and what does SNS do?”

CloudWatch collects metrics and logs, displays dashboards, and evaluates alarms. SNS distributes messages from an alarm or publisher to subscribers such as email or an incident system.

### “What does listening on port 80 mean?”

It means an application has bound to port 80 on a network interface and is waiting for incoming HTTP connections. A Security Group allowing port 80 is not enough if no process is listening there.

### “What does `/24` mean?”

An IPv4 `/24` contains 256 total addresses. AWS reserves five in a subnet, leaving 251 usable IPv4 addresses. A subnet’s size is available capacity, not the number currently being used by one resource.

### “What should I check first when an AWS application is down?”

Define the exact symptom, confirm account and Region, check DNS, then follow the request path through routes, Security Groups, listener, target health, process listening state, IAM calls, and logs. Use evidence from each boundary rather than changing random settings.

---

## 23. Compact glossary

| Term | Meaning |
| --- | --- |
| ALB | Application Load Balancer for HTTP/HTTPS application routing |
| AMI | Amazon Machine Image used to boot EC2 |
| ARN | Structured Amazon Resource Name used to identify resources in policies |
| ASG | EC2 Auto Scaling Group that maintains instance capacity |
| Availability Zone | Isolated location within an AWS Region |
| Cache hit | CloudFront finds a valid object at the edge and returns it without contacting the origin |
| Cache miss | CloudFront must fetch the object from the origin |
| CIDR | Notation describing an IP address range, such as `10.0.0.0/16` |
| CloudFront | AWS CDN and edge delivery service |
| CloudTrail | AWS API activity and audit trail |
| CloudWatch | Metrics, logs, dashboards, alarms, and observability service |
| Cluster | Logical grouping of ECS tasks and services |
| Container image | Packaged filesystem and metadata used to start a container |
| DNS | Name-resolution system that maps names to records |
| EBS | Block storage for EC2 |
| ECS | AWS container orchestration service |
| ECR | AWS container image registry |
| EFS | Managed shared network filesystem |
| Elastic IP | Persistent public IPv4 address allocated to an AWS account |
| ENI | Elastic Network Interface with private IPs, Security Groups, and subnet placement |
| Fargate | AWS-managed compute option for ECS tasks |
| Hosted zone | Route 53 collection of DNS records for a domain |
| IAM | AWS identity and access management service |
| IGW | Internet Gateway connecting VPC routes to the internet |
| Listener | ALB endpoint that waits on a protocol and port |
| Listener rule | ALB condition and action used to select a target group |
| NAT Gateway | Managed outbound internet path for private IPv4 resources |
| NACL | Stateless subnet-level network access control list |
| Origin | Source from which CloudFront retrieves content |
| Port | Logical network endpoint for an application |
| Private IP | VPC address used for internal networking |
| Private subnet | Subnet without a direct route to an Internet Gateway |
| Public IP | Internet-routable IPv4 address mapped to a private resource address |
| Public subnet | Subnet whose route table has an Internet Gateway route |
| Region | Geographic AWS location containing Availability Zones |
| Route table | Set of routes that selects the next network target |
| Route 53 | AWS DNS, domain, and routing service |
| S3 | Durable object storage service |
| Security Group | Stateful allow-based firewall for network interfaces |
| Service | ECS controller that maintains desired task count |
| SNS | Publish/subscribe notification service |
| Subnet | IP range inside a VPC tied to one AZ |
| Task | Running instance of an ECS task definition |
| Task definition | Versioned ECS container blueprint |
| Task role | IAM role used by application code inside an ECS task |
| Target group | ALB collection of destinations plus port and health checks |
| TTL | DNS or cache lifetime before a record/object is rechecked |
| VPC | Isolated virtual network boundary in AWS |
| VPC endpoint | Private path from a VPC to a supported AWS service |
| WAF | HTTP request filtering firewall for supported AWS edge services |

---

## 24. Official references

AWS documentation changes over time. Use these pages as the authoritative follow-up when a console field, quota, or service behaviour may have changed.

- [Amazon VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [VPC IP addressing](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html)
- [Public and private subnets with an Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
- [Subnet public IPv4 auto-assignment](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-public-ip.html)
- [VPC security groups and network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/infrastructure-security.html)
- [Application Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html)
- [How Elastic Load Balancing works](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html)
- [Amazon EC2 User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
- [Amazon Machine Images](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
- [Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)
- [Amazon ECR User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- [Amazon ECS architecture and configuration](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-configuration.html)
- [Amazon ECS task definitions and services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)
- [Fargate task networking](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-tasks-services.html)
- [IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
- [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
- [Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
- [Amazon EBS User Guide](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html)
- [Amazon EFS User Guide](https://docs.aws.amazon.com/efs/latest/ug/whatisefs.html)
- [Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)
- [Amazon Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [CloudFront origins and distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html)
- [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)
- [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html)
- [AWS Shield](https://docs.aws.amazon.com/waf/latest/developerguide/ddos-resiliency.html)
- [Amazon CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
- [CloudWatch alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [Amazon SNS](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)
- [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
- [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)

### Accuracy notes for facts that commonly change

- ALB subnet minimums, IP-capacity guidance, quotas, and service limits can change; verify the current ALB documentation before designing a production subnet.
- Public IPv4 pricing and defaults can change; check current EC2/VPC pricing and subnet settings.
- ECS/Fargate task CPU, memory, platform, and networking combinations can change; verify the current Fargate documentation.
- IAM managed policies can evolve; review the policy contents and reduce permissions rather than trusting a policy name alone.
- CloudFront cache behaviour, WAF managed rules, and service quotas should be confirmed for the specific project.

---

## 25. The one-page memory version

```text
AWS Region
└── Availability Zones
    └── VPC
        ├── Public subnets
        │   ├── Internet-facing ALB nodes
        │   └── NAT Gateway
        └── Private subnets
            ├── ECS/Fargate tasks or EC2 application instances
            ├── Internal services
            └── RDS

User
  ↓ DNS
Route 53
  ↓ optional edge cache/security
CloudFront
  ↓ HTTP/HTTPS listener
ALB
  ↓ target group and health check
ECS service
  ↓ desired count
Tasks
  ↓ private network
S3 / RDS / other services

ECR = stores the container image
ECS = schedules and maintains containers
Fargate = supplies managed task compute
EC2 = supplies virtual machines
Security Groups = network access
IAM = AWS action permissions
CloudWatch = logs, metrics, alarms
SNS = notifications

When something fails:
DNS → route → NACL/SG → listener → target health → listening process → IAM → logs
```

The shortest durable memory aid is:

> Route the user to a healthy entry point, allow only the intended network path, run the workload in the right compute model, give it only the AWS permissions it needs, store data in the right service, and monitor every important boundary.
