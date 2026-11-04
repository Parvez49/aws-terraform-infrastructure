# Networking notes

Study notes taken while building `modules/network`.

## VPC and addressing

**Q1. What is a VPC?**

A VPC is a logically isolated virtual network in AWS where we can launch and
manage AWS resources.

**Q2. What is CIDR?**

CIDR is a method of defining IP address ranges using an IP address and a network
prefix.

**Q3. Why do we use /16 in a VPC?**

We use /16 to get a large IP address range, allowing us to create multiple
subnets. /16 is also the largest block AWS accepts for a VPC; /28 is the
smallest.

**Q4. How many IP addresses are available in 10.0.0.0/16?**

65,536 total IP addresses.

**Q5. How many usable IP addresses are available in a /24 subnet in AWS?**

251 usable IP addresses, because AWS reserves 5 of the 256. For 10.0.1.0/24:

- `10.0.1.0` — network address
- `10.0.1.1` — VPC router
- `10.0.1.2` — DNS resolver (VPC base + 2)
- `10.0.1.3` — reserved for future use
- `10.0.1.255` — broadcast address, reserved even though VPCs do not support broadcast

**Q6. What is the difference between DNS Support and DNS Hostnames?**

They are two separate VPC attributes and both are enabled in
`modules/network/main.tf`:

- **`enable_dns_support`** controls whether the VPC's built-in DNS resolver
  answers queries at all. With it off, instances cannot resolve any DNS name
  through AWS, including internal records and public ones.
- **`enable_dns_hostnames`** controls whether instances *get* DNS names
  assigned. With it on, an instance with a public IP receives a public DNS name
  such as `ec2-3-25-71-65.ap-southeast-2.compute.amazonaws.com`.

So support is about *resolving* names, hostnames is about *being given* one.
`enable_dns_hostnames` has no effect unless `enable_dns_support` is also true.
Both are needed for the `instance_public_dns` output to be useful.

## Internet gateways and routing

**Q7. What is an Internet Gateway?**

An Internet Gateway is an AWS component that allows communication between a VPC
and the internet.

**Q8. Can we attach one Internet Gateway to multiple VPCs?**

No. An Internet Gateway can be attached to only one VPC at a time.

**Q9. What is a Route Table?**

A Route Table contains routing rules that determine where network traffic should
go.

**Q10. What is 0.0.0.0/0?**

It represents all IPv4 addresses and is commonly used as a default route.

**Q11. Is attaching an Internet Gateway enough to provide internet access to EC2?**

No. You also need:

- A route to the Internet Gateway (`aws_route.public_internet`).
- A public IPv4 address or Elastic IP (`map_public_ip_on_launch` on the subnet,
  plus `associate_public_ip_address` on the instance).
- Appropriate security group and network ACL rules.

**Q12. What is the difference between an Internet Gateway and a Route Table?**

- An Internet Gateway provides a connection between your VPC and the internet.
- A Route Table determines where network traffic should go.

A subnet is "public" only because its route table has a route to an internet
gateway. There is no public/private flag on a subnet itself.

**Q13. Why can nothing in the private subnet reach the internet here?**

Its route table has no `0.0.0.0/0` route. Outbound-only access from a private
subnet needs a NAT gateway, which costs roughly USD 32/month, so this project
does not run one. The route table exists so the subnet has an explicit
association rather than falling back to the VPC's main route table.
