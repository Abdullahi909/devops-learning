# Networking Project - Domain + EC2 + NGINX

## What I built

Registered my own domain (`abdullahimohamed.uk`), spun up an EC2 instance on AWS, installed NGINX, and pointed the domain at the server using DNS. When you hit `abdullahimohamed.uk` in a browser, it loads the NGINX welcome page served from my EC2 instance.

## Tools used

- AWS EC2 (Amazon Linux)
- NGINX
- Cloudflare (domain registration + DNS)

## Steps

### 1. Bought the domain

Registered `abdullahimohamed.uk` through Cloudflare. Went with my full name so I can reuse this domain across future projects.

### 2. Launched an EC2 instance

- Chose Amazon Linux as the AMI
- Created a new key pair for SSH access
- In the network settings, ticked "Allow HTTP traffic from the internet" (port 80) and kept SSH (port 22) open

### 3. SSH'd into the instance

Connected to the instance from my terminal using the `.pem` key file:

```bash
ssh -i "my-key.pem" ec2-user@<public-ip>
```

### 4. Installed and started NGINX

```bash
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

Grabbed the public IPv4 address from the AWS console and pasted it into my browser to confirm NGINX was running before touching DNS.

### 5. Configured DNS in Cloudflare

- Went to DNS settings for `abdullahimohamed.uk` in Cloudflare
- Added an A record
- Name: `@` (root domain)
- Value: my EC2 public IPv4 address
- Waited a couple of minutes for propagation

### 6. Tested it

Hit `abdullahimohamed.uk` in the browser and the NGINX welcome page loaded.


## What I learned

- How security groups control what traffic reaches your instance — without port 80 open, nobody can hit the web server
- How an A record maps a domain name to an IP address
- The full chain: browser → DNS lookup → Cloudflare returns the IP → request hits EC2 → security group allows port 80 → NGINX serves the page
