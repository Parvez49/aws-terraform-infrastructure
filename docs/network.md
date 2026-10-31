
Q1. What is a VPC?

A VPC is a logically isolated virtual network in AWS where we can launch and manage AWS resources.

Q2. What is CIDR?

CIDR is a method of defining IP address ranges using an IP address and a network prefix.

Q3. Why do we use /16 in VPC?

We use /16 to get a large IP address range, allowing us to create multiple subnets.

Q4. How many IP addresses are available in 10.0.0.0/16?

65,536 total IP addresses.

Q5. How many usable IP addresses are available in a /24 subnet in AWS?

251 usable IP addresses because AWS reserves 5 addresses.

Q6. What is the difference between DNS Support and DNS Hostnames?

Q1. What is an Internet Gateway?

An Internet Gateway is an AWS component that allows communication between a VPC and the internet.

Q2. Can we attach one Internet Gateway to multiple VPCs?

No. An Internet Gateway can be attached to only one VPC at a time.

Q3. What is a Route Table?

A Route Table contains routing rules that determine where network traffic should go.

Q4. What is 0.0.0.0/0?

It represents all IPv4 addresses and is commonly used as a default route.

Q5. Is attaching an Internet Gateway enough to provide internet access to EC2?

No. You also need:

    A route to the Internet Gateway.
    A public IPv4 address or Elastic IP.
    Appropriate security group and network ACL rules.

Q6. What is the difference between an Internet Gateway and a Route Table?

    Internet Gateway provides a connection between your VPC and the internet.
    Route Table determines where network traffic should go.