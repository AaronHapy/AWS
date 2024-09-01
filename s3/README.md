# S3 / Simple Storage Service.

AWS S3 bucket are highly scalable and secure containers used to store and retrieve any amount of data from anywhere on the web.They are commonly used for backup and restore, data archiving, website hosting, and distributing content.

## Bucket policies
Bucket policies are a way to control access to our s3 buckets and their content. These policies are written in JSON format and define the permissions and restrictions for different users, groups, or applications interacting with the s3 bucket.

### JSON - Based Policies
S3 bucket policies are expressed in JSON (JavaScript Object Notation) format, providing a structured and readable way to define access controls.

### Access Control Elements

- **Principals**: Specifies the AWS accounts, IAM users, IAM roles, federated users, or AWS services to which the policy is applied.
- **Actions**: Defines the specific operations (e.g. GetObject, PutObject) that are allowed or denied.
- **Resources**: Identifies the amazon S3 resources (e.g. buckets, objects) to which the policy applies.
- **Conditions**: Optionally includes conditions that must be satisfied for the policy to take effect.

### Common Use Cases

- Public Access: Define policies to allow or deny public access to the entire bucket or specific objects within it.
- Cross-Account Access: Grant permissions to AWS accounts other than the account that owns the S3 bucket.
- IAM User and Role Access: Specify permissions for IAM users and roles within the same AWS account.
- Restricting Access by IP: Set up policies to allow access only from specific IP addresses or ranges.

---


**More about S3**
- Secure, Durable and Highly available Object Storage
- Object => Any File (txt, csv, img, css, movie, mp3, etc, etc)
- An Object can be 0 bytes to 5 TB.
- "unlimited" storage.
    - We can store N number of objects.
    - Amazon would charge based on "per GB"
        - There are various factors... but to give an idea . $0.02 / GB / Month
        - Search for AWS S3 Pricing