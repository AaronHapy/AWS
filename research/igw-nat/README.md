# Difference between Internet Gateway and NAT Gateway

## TL;DR:

- Internet Gateway (IGW) allows instances with public IPs to access the internet.
- NAT Gateway (NGW) allows instances with no public IPs to access the internet.

## Internet Gateway

- Internet Gateway (IGW) is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet.

- Internet Gateway enables resources (like EC2 instances) in public subnets to connect to the internet.
Similarly, resources in the internet can initiate a connection to resources in your subnet using the public.

- If a VPC does not have an internet gateway, then the resources in the VPC cannot be accessed from the internet (unless the traffic flows via a corporate Network and VPN/Direct Connect).

- Internet Gateway supports IPv4 and IPv6 traffic.

- Internet Gateway does not cause availability risks or bandwith contraints on your network traffic.

- In order to make subnet public, add a route to your subnet's route table that directs internet-bound traffic to the internet gateway.

- You can associate exactly one Internet gateway with a VPC.

- Internet Gateway is not availability zone specific.

- There's no additional charge for having an internet gateway in our account.


## NAT Gateway

- NAT Gateway (NGW) is managed Network address translation (NAT) service.

- NAT Gateway does something similar to internet gateway (IGW), but it only works one way: Instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.

- NAT gateway are supported for IPv4 and IPv6 traffic.

- NAT Gateway supports the following protocols: TPC, UDP, and ICMP.

- Each NAT gateway is created in a specific availability zone and implemnted with redundancy in that zone.

- If you have resources in multiple availability zones and they share one NAT gateway, and if the NAT gateway's availability zone is down, resources in the other availablity zones lose internet access.

- To create an availability zone -independent architecture, create a NAT gateway in each availability zone.

- You can associate exactly one Elastic IP address with a public NAT gateway.

- You are charged for each hour that your NAT gateway is available and each Gigabyte of data that it processes.

NAT gateway replaces the source IP address of the instances with the IP address of the NAT gateway.