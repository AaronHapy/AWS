# EC2 / Elastic Computing Cloud

**cloud terminologies**
- Region
- Availability Zone (AZ)
- Edge Location / Point of Presence (POP)

**ec2**
- Elastic Computing Cloud
- Service which provides resizable computing capacity in the cloud!
- Launch a VM in a minute!
    - OS / AMI (Amazon Machine Image)
    - CPU / Memory
- Scale up and down depending on the requirements.


## EC2 - Pricing Model

| Model      | Description |
| ----------- | ----------- |
| on-demand      | Launch a VM. Use it as long as you want. Pay / hour basis       |
| reserved   | Reserve a VM for 1 year or 3 years        |
| dedicated   | Fully dedicated physical hardware in the cloud for your use!        |
| spot   | Up to 90% discount (Unused VMs in the Data Center. AWS might reclaim these instances any moment - with a 2 minutes warning)        |

**security group** is a set of firewall rules that control the traffic for our instance. Add rules to allow specific traffic to reach our instance.

**ARN** = Amazon Resource Name

**Monitoring** = CPU / Network packet metrics. Memory is not included by default.