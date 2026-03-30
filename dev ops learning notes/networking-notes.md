# Networking Module notes

These notes cover only the areas I got wrong or couldn't answer during active recall. Everything else (networking components, MAC addresses, OSI layers, TCP vs UDP, static vs dynamic routing, NAT, VPCs) is already locked in.

---

## 1. DNS Resolution Order

This is the full chain when you type a domain into your browser for the first time (nothing cached):

1. **Browser → DNS Resolver** — your browser only ever talks to the resolver. It's the middleman that does all the legwork.
2. **Resolver → Root Server** — resolver asks: "who handles `.com`?" Root says: "go ask this TLD server."
3. **Resolver → TLD Server** — resolver asks: "who handles `google.com`?" TLD says: "go ask this authoritative server."
4. **Resolver → Authoritative Name Server** — resolver asks: "what's the IP for `google.com`?" Authoritative server returns the actual IP.
5. **Resolver → Browser** — IP returned to the user, browser connects.

Key thing to remember: the resolver is always step 1. Your browser never contacts root or TLD servers directly. The resolver is a research assistant — you ask it one question, it goes off and does the chain on your behalf.

### Domain Hierarchy

```
Root Domain (.)
    └── TLD (.com, .uk, .org)
        └── Second Level Domain (google.com, abdullahimohamed.uk)
            └── Subdomain (www.google.com, mail.google.com)
```

---

## 2. DNS Record Types

| Record | What it does | Example | When to use |
|--------|-------------|---------|-------------|
| **A** | Maps domain → IPv4 address | `google.com → 216.58.204.79` | Pointing a domain to a server |
| **AAAA** | Maps domain → IPv6 address | `google.com → 2a00:1450:...` | Same but for IPv6 |
| **CNAME** | Alias — points one domain name to another domain name | `www.google.com → google.com` | When you want a subdomain to follow another domain's IP automatically |
| **MX** | Specifies the mail server for a domain | `google.com → mailserver.google.com` | Email delivery only |
| **TXT** | Stores text data for a domain | `"v=spf1 include..."` | Verification, SPF, DKIM |
| **NS** | Specifies which name servers are authoritative for a domain | `google.com → ns1.google.com` | Delegating DNS authority |

### The CNAME vs MX confusion

- **CNAME** = "this name is an alias for that name." General purpose redirect. Think of it as "go look over there instead."
- **MX** = "deliver email for this domain to this mail server." Only for email routing. Includes a priority value so you can set backup mail servers.

If someone asks "point subdomain X to the same place as domain Y without hardcoding an IP" — that's always **CNAME**.
If someone asks "where should emails for this domain be delivered" — that's **MX**.

---

## 3. DNS Tools

| Tool | Purpose | Example |
|------|---------|---------|
| **ping** | Tests if you can reach a host + measures round-trip time | `ping google.com` — "can I get there?" |
| **nslookup** | Basic DNS lookup — returns the IP for a domain | `nslookup google.com` — quick and simple |
| **dig** | Advanced DNS lookup — returns record type, TTL, authoritative server, query time, full answer section | `dig google.com` — the full picture |
| **traceroute** | Shows every hop a packet takes to reach a destination | `traceroute google.com` — path mapping |

### When to use what

- "Is the server reachable?" → `ping`
- "What IP does this domain resolve to?" → `nslookup` (quick) or `dig` (detailed)
- "I need TTL, record type, which nameserver answered" → `dig` (always dig for DNS debugging)
- "Where is the packet getting stuck on the way there?" → `traceroute`

Try this on your own domain:
```bash
dig abdullahimohamed.uk
```
You'll see Cloudflare's nameservers in the authority section since that's where you registered it.

---

## 4. Subnetting

### The core formula

**Usable hosts = 2^(host bits) − 2**

The "minus 2" is because you always lose two addresses: the network address (first) and the broadcast address (last). You can never assign these to devices.

### How to calculate host bits

Start with 32 (total bits in an IPv4 address). Subtract the prefix length.

- /24 → 32 - 24 = **8 host bits** → 2^8 - 2 = **254 usable hosts**
- /25 → 32 - 25 = **7 host bits** → 2^7 - 2 = **126 usable hosts**
- /26 → 32 - 26 = **6 host bits** → 2^6 - 2 = **62 usable hosts**
- /27 → 32 - 27 = **5 host bits** → 2^5 - 2 = **30 usable hosts**
- /28 → 32 - 28 = **4 host bits** → 2^4 - 2 = **14 usable hosts**

### How to split a network into subnets

Question: "Split 10.0.0.0/24 into 4 equal subnets."

Step 1 — How many bits do I borrow? Find the power of 2 that gives you enough subnets:
- 2^1 = 2 (not enough)
- 2^2 = 4 (that's the one — borrow 2 bits)

Step 2 — Add borrowed bits to the prefix: /24 + 2 = **/26**

Step 3 — Calculate the block size: 2^(remaining host bits) = 2^6 = 64 addresses per subnet

Step 4 — List the subnets (each starts 64 apart):

| Subnet | Network Address | Usable Range | Broadcast |
|--------|----------------|--------------|-----------|
| 1 | 10.0.0.0/26 | 10.0.0.1 – 10.0.0.62 | 10.0.0.63 |
| 2 | 10.0.0.64/26 | 10.0.0.65 – 10.0.0.126 | 10.0.0.127 |
| 3 | 10.0.0.128/26 | 10.0.0.129 – 10.0.0.190 | 10.0.0.191 |
| 4 | 10.0.0.192/26 | 10.0.0.193 – 10.0.0.254 | 10.0.0.255 |

### Subnet mask ↔ CIDR conversion

| CIDR | Subnet Mask | Usable Hosts |
|------|-------------|-------------|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |

---

## 5. Security Groups vs NACLs (AWS)

| | Security Groups | NACLs |
|--|----------------|-------|
| **Stateful vs Stateless** | **Stateful** — if you allow inbound, the return traffic is automatically allowed out | **Stateless** — you must explicitly allow both inbound AND outbound rules |
| **Operates at** | Instance level (attached to EC2) | Subnet level (covers everything in the subnet) |
| **Default behaviour** | Denies all inbound, allows all outbound | Allows all inbound and outbound by default |
| **Rule type** | Allow rules only (no deny rules) | Both allow and deny rules |
| **Evaluation** | All rules evaluated together | Rules evaluated in order (lowest number first) |

### What stateful vs stateless actually means

**Stateful (Security Groups):** You create one rule: "allow inbound on port 80." When traffic comes in on port 80, the Security Group remembers that connection and automatically lets the response go back out. No outbound rule needed for return traffic.

**Stateless (NACLs):** You create a rule: "allow inbound on port 80." Traffic comes in — fine. But the response tries to go back out and gets blocked because the NACL has no memory of the connection. You need a separate outbound rule to allow the response.

### Real-world example

When I set up NGINX on EC2 for abdullahimohamed.uk, I had to add an inbound rule to the Security Group allowing port 80 (HTTP). Because Security Groups are stateful, I didn't need to add a separate outbound rule — the response traffic was automatically allowed.

If I had been using NACLs instead, I would have needed both an inbound rule for port 80 AND an outbound rule for the ephemeral port range (1024-65535) to allow the response.
