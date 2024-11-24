# VPC (Virtual Private Cloud)

VPC is a service that allows you to create a private, isolated network within the AWS cloud. With VPC, you can 
launch resources in a virtual network that you define. VPC provides you with complete control over your virtual networking environment,
including IP addressing, subnets, routing tables, and network gateways.

**Why use AWS VPC?**

AWS VPC allows you to create a secure and isolated network for your resources, which provides a high level of security and control.
This means that you can create your own private network, which is not accessible from the internet or other networks. AWS VPC also
enables you to create a VPN connection between your on-premises infrastructure and your AWS VPC. This connection allows you to access
resources in your VPC from your on-premises infrastructure.

When we create our AWS account, the regions come with a default VPC.

<img src="./images/2.png" alt="Alt Text" width="500" />

![image](./images/3.png)
![image](./images/10.png)


**Region / AZ**
![image](./images/1.png)

**Subnet**

A subnet is a range of IP addresses in your VPC. You can launch resources, such as EC2 instances and RDS databases, in a subnet. You can also assign different subnets to different availability zones to achieve high availability and faul tolerance.

- Logical subdivision of IP address range within VPC
    - VPC => House
    - Subnet => Room
- Subnets resides within a single AZ
- We create EC2 instances, Databases, ALBs into specific subnets.
- Benefits
    - Isolating resources within VPC
    - Control inbound and outbound traffic

![image](./images/4.png)

**Public Subnet**

A public subnet is a subnet that is accessible from the internet. so that subnet can access to the world wide web and also can be accessed fron the world wide web.

- Each region comes with a default VPC.
    - Default VPC has 1 subnet per AZ
        - It is a public subnet.
        - A subnet which has direct access to the internet.
- If we need to allow our application to be accessible from the internet, then the application has to be placed inside this public subnet.
    - (Could be a security risk)


- Security Risk
- Security Group is not enough!
    - People make mistakes!
- We have had many data breaches!
    - Not because of AWS
    - Poor understanding of network config / firewall rules etc

**Private Subnet**

A private subnet is a subnet that is not accessible from the internet.

- How can an instance in the private subnet can call services in the internet/outside VPC, if required?
- Note
    - Private subnet instances do not have public IPs
    - We cannot associate internet gateway to private subnets

![alt text](./images/14.png)

**Internet Gateway**

- Internet Gateway helps our VPC instances connect with the internet.
- Public subnets have a route to the internet gateway.

public subnets will have a route to an internet gateway.

An internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows you 
communication between instances in your VPC and the internet.   

![image](./images/5.png)


**Recommended Approach for when creating VPCs**

- Create our own VPC for our applications!
    - With multiple subnets across multiple AZs to provide high availability and fault tolerance.
- Customize network settings / IP address ranges
- Deploy our application in private subnets which are NOT directly reachable in the internet.
- Use AWS resources like CloudFront / ALB as front-facing while our application is hidden behind these AWS resources in private subnets.
- Our app can be accessed only via ALB / CloudFront (using security groups / bucket policies)

![image](./images/8.png)

## CIDR

CIDR (Classless Inter-Domain Routing) is just a part or an extension of an IP. CIDR is nothing but a range of IP addresses a network uses. It is 
also called supernetting. 

The internet protocol (IP) is a set of rules, for addressing packets of data so that they can travel across networks and arrive at the 
correct destination. An IP address is a unique string of characters that identifies each computer using the internet protocol to communicate over a network.

- IPv4: It is the first version of the internet protocol address. In this internet protocol security (IPSec) with respect to network security is optional.

- IPv6: It is the recent version of the internet protocol address. In this internet protocol security (IPSec) with respect to network security is mandatory.

**Classification of IP addresses**:

For technical reasons, the allocation of IP addresses has to follow the topology of the network and not geography or national borders.
Therefore, the addresses are allocated for use in specific networks, as they are required. On the basis of addressing, IP addresses are divided into two classes, they are:

- Classful IP addressing.
- Classless IP addressing (or) CIDR

**Classful Addressing**:

Classful addressing is an IPv4 addressing architecture that divides the 32-bit IP address into five sub-classes, witch each class with a valid range of IP. every IPv4 address can be divided into two parts.

Network ID: Identifies the specific network where the device is located.
Host ID: Identifies a specific device in that network.

Example: 

192.168.32.170, the network id would be: 192.168.32 and the hostId would be: 170

In simple words Host ID is like your door number and network Id is like the rest of your address containing street name, state, country. 

**Classless IP addressing (or) CIDR**
In order to reduce the wastage of IP addresses a new concept of Classless Inter-Domain Routing is introduced. In CIDR the block of IP addresses is assigned dynamically based on specific rules. CIDR is a group of IP addresses that are allocated to the customer when they demand a fixed number of IP addresses.

![image](./images/9.png)

- VPC - PROD
    - 10.0.0.0 / 16
    - Subnet - 1
        - 10.0.1.0/24
    - Subnet - 2
        - 10.0.2.0/24
            - EC2 - 10.0.2.18
    - Subnet - 3
        - 10.0.3.0/24
    - Subnet - 4
        - 10.0.4.0/24

**Route Table**

To define access to the internet and between subnets, we use Route Tables.

A set of rules - called routes - which determine where network traffic from the subnet is directed.
![alt text](./images/11.png)

EC2 instance in the private subnet cannot be accessed directly from the internet even if it has public IP, also
EC2 instance in the private subnet cannot access internet directly.


**NAT Gateway**
NAT gateways (AWS-managed) & NAT instances (self-managed) allow your instances in your Private Subnets
to access the internet while remaining private.

A network address translation (NAT) gateway enables instances in a private subnet to connect to the internet or others AWS
services while preventing the internet from initiating connections with the instances.

**Network ACL & Security Groups**
NACL (Network ACL)
- A firewall which controls traffic from and to subnet
- Can have ALLOW and DENY rules
- Are attached at the Subnet level
- Rules only include IP addresses.

Security Groups
- A firewall that controls traffic to and from an ENI (elastic network interface) / an EC2 instance.
- Can have only ALLOW rules
- Rules includes IP addresses and other security groups.

![alt text](image-1.png)
![alt text](image-2.png)

**VPC Flow Logs**
Capture information about IP traffic going into your interfaces:
- VPC Flow Logs
- Subnet Flow Logs
- Elastic Network Interface Flow Logs

Helps to monitor & troubleshoot connectivity issues. Example:
- Subnets to internet
- Subnets to subnets.
- Internet to subnets.

Captures network information from AWS managed interfaces too: 
Elastic Load Balancer, ElasticCache, RDS, Aurora, etc...

VPC Flow Logs data can go to S3, CloudWatch Logs, and kinesis Data Firehose

**VPC peering**
- Connect two VPC, privately using AWS' network
- Make them behave as if they were in the same network.
- Must not have overlapping CIDR (IP address range)
- VPC Peering connection is not transitive (must be established for each VPC
 that need to communicate with one another)

 ![alt text](image-3.png)


**VPC Endpoints**
- Endpoints allow you to connect to AWS services using a private network instead of the public www network.
- This gives you enhanced security and lower latency to access AWS services.
- VPC endpoint gateway: S3 & DynamoDB
- VPC endpoint interface: the rest
- Only used within your VPC

![alt text](image-4.png)

**Site to Site VPN & Direct Connect**
Site to Site VPN
- Connect an on-premise VPN to AWS
- The connection is automatically encrypted.
- Goes over the public internet.

Direct Connect (DX)
- Establish a physical connection between on-premises and AWS.
- The connection is private, secure and fast.
- Goes over a private network.
- Takes at least a month to establish.

![alt text](image-5.png)

**Typical 3 tier solution architecture**
![alt text](image-7.png)

LAMP Stack on EC2
- Linux: OS for ECS instances.
- Apache: Web Server that run on Linux (EC2)
- MySQL: database on RDS
- PHP: Application logic (running on EC2)
- Can add Redis / Memcached (ElastiCache) to include a caching tech
- To store local application data & software: EBS drive (root)

![alt text](image-8.png)

![alt text](image-9.png)


**What the VPC looks like at a high level**
![alt text](image.png)


**Summary**
![alt text](image-6.png)
