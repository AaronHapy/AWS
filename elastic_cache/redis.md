## Redis in Amazon ElastiCache
Redis is one of the supported in-memory data stores in Amazon ElastiCache. It is an open-source, advanced
key-value store known for its high performance, flexibility, and rich feature set.

In order to create a redis cluster, let's go to Amazon ElastiCache section in AWS, whick in getstarted button and then choose redis.
the deployment option we have 2 options, serverless and build our own cache, let's choose the build our own cache and then,
choose easy create for this example.

then in configuration section, choose dev/test for this purpose, then give a name for the cluster



Deployment option: Design your own cache
creation method: Cluster cache
cluster mode: Disabled
cluster-info
    name: my-redis
    description: my redis for youtube demo
Location: 
    location: AWS Cloud
    Multi-AZ: disabled
    fail-over: disabled
Cluster-settings:
    Engine version 7.1
    port: 6379
    Parameter groups: default.redis7
    Node type: cache.r5.large
    Number of replicas: 2
Connectivity:
    Network type: IPV4
    Subnets grops:
        Create a new subnet group:
            name: some-name
            description: some-description
            VPC ID: some-vpc-id
    select subnets: some seelcted subnets
Security:
    Encryption at rest: Enabled
    Escription key: Default key option
    Encryption in transit: Emabled
    Access control: Redis AUTH default user access
    Redis AUTH token: some-string-secure
    Selected security groups: (Create some secure groups and then selected there) (the inbound rule needs to be type: TPC, port: 6379, source: 0.0.0.0/0)
Backup: disabled
Maintenance:
    Maintenance window: no-preference
    auto upgrade minor versions: disabled
    notifications: disabled
Logs:
    show logs: Enable
    log Format: JSON
    Log destination tyoe: Cloud Watch logs
    Log destination: create a new log group
    log group name: some-group-name

create!!