# Netflux

**AWS architecture**:

- VPC + Security Groups
- ALB + Target Groups + Listener Rules
- S3 + CDN
- RDS + Secrets Manager
- ECR
- Finally => Fargate



## Create VPC

To create the VPC, follow the same steps outlined in the [VPC section of this repository](https://github.com/AaronHapy/AWS/tree/main/vpc/create). However, for this setup, we’ll need to create three different security groups.

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
