# How to create a VPC

## Create VPC 

To create a VPC in AWS, navigate to the VPC service and click on the **Create** button. This will redirect you to the VPC creation page. The first option you'll see is the **Resources to create** section, where you'll have two choices: **VPC only** and **VPC and more**. Choose **VPC and more**. Next, enter a name for your VPC, and review the IPv4 CIDR block. The default is typically set to `10.0.0.0/16`, which is suitable for now.

The next thing to consider is the number of Availability Zones (AZs), which by default is set to 2. That's fine for now. In this case, we want to have 1 public subnet per Availability Zone. AWS provides 2 by default, which is perfect. For the private subnets, we want to have 4. By default, AWS provides 2, so we can change that to 4.

Next, we need to customize our subnets' CIDR blocks. Each subnet needs a specific range; for example, the first one could be `10.0.1.0/24`, the second one `10.0.2.0/24`, and so on.

We'll also need to enable the NAT gateway, but for now, let's disable it by choosing the **None** option. Do the same for VPC endpoints. Ensure that DNS for hostnames and resolution is checked, and finally, create the VPC.

## Route Table

Once the VPC is created, let's take a look at the Route Table. This is a set of rules, called routes, that determine where network traffic from the subnet is directed. A public subnet needs to have 2 entries: one with a destination of `0.0.0.0/0`, targeting the internet gateway, and another that points to local communication.

## Subnets

Next, go to the **Subnets** section, select the first public subnet, and once it's selected, a small window with more information about the subnet will appear at the bottom of the UI. Click on the **Route Table** tab to display the route table entries.

Next, we need to connect to the private subnet. To minimize security risks, we'll first connect to the public subnet, and from there, connect to the private subnet.

## EC2 

To do this, go to the **EC2** dashboard, select **Key Pairs** under the **Network & Security** section, and create a key pair. Provide a name for the key, choose the **RSA** key pair type, and select **pem** as the private key file format.

Next, we need to create a Security Group to allow SSH connections so we can connect to the instance. Create a Security Group, give it a name and description, and select the VPC we created earlier. Add a new inbound rule to accept SSH connections: set the type to **SSH** and the destination to `0.0.0.0/0`.

Then, create two EC2 instances—one in the private subnet and one in the public subnet. For the private subnet instance, don't add a custom security group since we don't need to connect to it directly; choose the default one. For the public subnet instance, remember to enable the public IP address.

Once both EC2 instances are created, connect to the public instance using the SSH key, and test the connection by pinging `google.com` (it should ping successfully).

Once that task is completed, we need to copy the content of the `.pem` key file and create the file inside the public instance. You can do this by running the following command:

```bash
cat > keypair.pem
```

Press **Enter**, paste the key content, then press **Enter** again and use `Ctrl + C` to save and exit.

Next, connect to the private instance using its private IP address, since it doesn't have a public IP for security reasons.

Once connected successfully, try pinging `google.com`. The ping will fail because an EC2 instance in a private subnet can only access the internet through a NAT gateway, which communicates with the internet gateway.

To create a NAT gateway, go to the **NAT Gateways** section in the **VPC** dashboard, click the **Create** button, and give the NAT gateway a name. Select the public subnet, then assign an Elastic IP by clicking on **Allocate Elastic IP**. Finally, create the NAT gateway.

Next, assign the NAT gateway to the route table of the private subnet. Go to the subnet (the private one you want to allow internet access), select the route table configuration, and click **Edit routes**. Add a new entry where the destination is `0.0.0.0/0` and the target is the NAT gateway. Select the NAT gateway you created earlier.

Finally, connect to the private instance in the private subnet and ping `google.com`—it should be successful.


To clean up this work, terminate both EC2 instances, delete the NAT gateway, release the Elastic IP, and finally, delete the VPC.
