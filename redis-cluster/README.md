# Running

```
sudo docker compose up -d

sudo docker network inspect redis-cluster_redis-cluster | grep Name
        "Name": "redis-cluster_redis-cluster",
                "Name": "redis-master-3",
                "Name": "redis-slave-3",
                "Name": "redis-master-2",
                "Name": "redis-slave-1",
                "Name": "redis-master-1",
                "Name": "redis-slave-2",

sudo docker exec -it redis-master-1 redis-cli \
  --cluster create \
  redis-master-1:6379 redis-master-2:6379 redis-master-3:6379 \
  redis-slave-1:6379 redis-slave-2:6379 redis-slave-3:6379 \
  --cluster-replicas 1 -a test123

Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.....
```