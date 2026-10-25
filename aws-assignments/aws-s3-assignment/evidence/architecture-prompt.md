# Architecture illustration generation

The Assignment 3 illustration was produced with the built-in **imagegen** tool. The existing assignment images were supplied as visual references; the AWS console screenshots were copied unchanged and were not generated.

- Output: [aws-s3-cloudfront-route53.png](aws-s3-cloudfront-route53.png).
- Reference 1: [Assignment 2 ALB illustration](../../aws-alb-assignment/evidence/aws-application-load-balancer.png).
- Reference 2: [Assignment 1 VPC illustration](../../aws-vpc-assignment/evidence/aws-vpc-networking.png).
- Background: opaque white.
- The illustration shows the S3 REST origin visible in the supplied console evidence. It is not an AWS configuration export.

## Prompt

```text
Use case: style-transfer / infographic-diagram. Create the Assignment 3 counterpart to these two existing AWS assignment architecture illustrations. Image 1 is the ALB illustration to transform; Image 2 is a second style reference. Preserve their exact visual family: a wide landscape technical diagram on a white background, a large very pale sky-blue AWS service-area rectangle with a thin cyan outline and gently rounded corners, pale green regional grouping, dark navy clean sans-serif labels, thin muted blue-grey orthogonal arrows, flat AWS-style colored service icons, restrained soft color variation and ample whitespace. Keep it visually consistent with the two references when placed above a numbered screenshot list in a GitHub README. Replace the entire old ALB/VPC topology with the accurate architecture below. This is an illustrative diagram, never a fake AWS screenshot.

Title at top inside the blue area: 'Assignment-3 | S3 + CloudFront + Route 53'. Do NOT call the blue area a VPC: these are AWS managed services, with CloudFront and Route 53 global, S3 in eu-west-2, and ACM in us-east-1. Do not include subnets, EC2, load balancers, internet gateways or NAT gateways.

Composition: laptop/browser icon outside the blue area on the far left at middle height, labeled 'Visitor / browser' and 'abdullahiaws.uk'. Main content flow is a clean horizontal arrow from this browser to a central purple CloudFront icon, labeled 'HTTPS'. CloudFront has labels 'CloudFront distribution', 'assignment3', 'Edge cache'. A horizontal arrow from CloudFront to a green Amazon S3 bucket icon on the right is labeled 'Origin fetch on cache miss'. Place the S3 icon inside a pale green rounded regional group headed 'S3 | eu-west-2', with labels 'Amazon S3 bucket', 'index.html', 'REST bucket origin'. The actual configured origin is a regular S3 REST bucket origin, not an S3 website endpoint. Do not label the bucket private or public and do not invent access policies. Do not label the CloudFront-to-S3 connection with an unverified protocol.

Supporting nodes above the main flow: a purple Route 53 icon upper left inside the blue area, labeled 'Route 53', 'abdullahiaws.uk', 'A + AAAA aliases'. A dashed line between the browser and Route 53, clearly labeled 'DNS lookup'; a separate dashed association between Route 53 and CloudFront, labeled 'Alias target'. Route 53 must NOT be drawn as a proxy in the HTTPS content flow. An ACM certificate icon in upper right is labeled 'ACM certificate', 'us-east-1 | Issued'. A dashed connection from ACM to CloudFront is labeled 'TLS certificate'. All connections must terminate at their correct services without crossing text.

A modest pale annotation box below CloudFront contains three readable lines: 'HTTPS only', 'Managed-CachingOptimized', 'Default root: index.html'. No long resource IDs, no AWS account number, no error.html (not present in the supplied evidence), no unverified compression or HTTP method settings. All text exact and readable. Use a small unobtrusive key if needed to distinguish dashed DNS/configuration relationships from solid content requests, without excessive labels.

Footer centered beneath the blue area, matching the reference footer placement: 'S3 Static Website + CloudFront + Route 53 | Assignment 3'. Second smaller footer line: 'Illustrative architecture | Configuration shown in evidence'. Maintain the reference aspect ratio about 1.8:1 and polished high resolution. The illustration must be technically accurate, uncluttered, no overlapping labels, no repeated nodes, no decorative extra services.
```
