# Netflux

**AWS architecture**:

- VPC + Security Groups
- ALB + Target Groups + Listener Rules
- S3 + CDN
- RDS + Secrets Manager
- ECR
- Finally => Fargate



## Create VPC

In order to create the VPC, you can follow the same steps on [VPC section -> create - of this repository](https://github.com/AaronHapy/AWS/tree/main/vpc/create), with the exception that in this case we'll need to create 3 different security groups, the first security group is for the application load balancer (ALB), so create a new security group with the name of {ourapp}-alb-sg, the description is "allow external traffic to alb" and choose the VPC created above. the inbound rule we'll need in this case is to allow requests from anywhere 0.0.0.0/0 for port 80 (http).

the next security group is for the microservices applications, the name could be {ourapp}-app-sg, the description could be "allow traffic from alb to app" and then choose the VPC created above. the inbound rule we'll need in this case is to allow traffic from ALB, so the port needs to be 8080 and the source select the alb security group and then create the security group, in this case we need to remember that apps talk among themselves customer-service will want to talk to movie-service to get the movie information. However the current rule is explicitly to allow the traffic from ALB. so les't edit the security group of apps, and add a new inbound rule where it is a custom TPC, port 8080 and the source is app security group. 


To create the VPC, follow the same steps outlined in the VPC section of this repository. However, for this setup, we’ll need to create three different security groups.

1. **Application Load Balancer (ALB) Security Group**:  
   - **Name**: `{ourapp}-alb-sg`  
   - **Description**: "Allow external traffic to ALB"  
   - **VPC**: Select the VPC created earlier.  
   - **Inbound Rule**: Allow HTTP traffic from anywhere (`0.0.0.0/0`) on port 80.

2. **Microservices Application Security Group**:  
   - **Name**: `{ourapp}-app-sg`  
   - **Description**: "Allow traffic from ALB to app"  
   - **VPC**: Select the same VPC.  
   - **Inbound Rule**: Allow traffic from the ALB security group on port 8080.

   Remember, microservices (e.g., customer-service and movie-service) need to communicate with each other. While the initial rule allows traffic from the ALB, we need to edit the app security group to add another rule.

    **Microservices Communication Rule**:  
    - Add a new inbound rule:  
        - **Type**: Custom TCP  
        - **Port**: 8080  
        - **Source**: The app security group itself, allowing inter-service communication.

3. **DB Security Group**:  
   - **Name**: `{ourapp}-db-sg`  
   - **Description**: "Allow traffic from backend apps"  
   - **VPC**: Select the VPC created earlier.  
   - **Inbound Rule**: Allow PostgresSQL traffic from the app-sg on port 5432.


## Target Groups

- Target Groups
    - movie-service-containers
    - customer-service-containers
- ALB
    - Listener Rules
        - /api/movies* => movie-service-containers
        - /api/customers/* => customer-service-containers

**ALB + Target Group**

![alt text](./images/1.png)   
