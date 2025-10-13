# Running

```
sudo docker compose up -d

sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-master-1
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-master-2
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-master-3
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-slave-1
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-slave-2
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-slave-3

sudo docker exec -it redis-master-1 redis-cli \
  --cluster create \
  172.22.0.2:6379 172.22.0.6:6379 172.22.0.4:6379 \
  172.22.0.7:6379 172.22.0.5:6379 172.22.0.3:6379 \
  --cluster-replicas 1 -a test123
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 172.22.0.5:6379 to 172.22.0.2:6379
Adding replica 172.22.0.3:6379 to 172.22.0.6:6379
Adding replica 172.22.0.7:6379 to 172.22.0.4:6379
M: b054cd8ec15e7fbf8b5ea5537405735e17ae8129 172.22.0.2:6379
   slots:[0-5460] (5461 slots) master
M: 2eebd2c8af7c6d13be13d131b78420c22c8eb888 172.22.0.6:6379
   slots:[5461-10922] (5462 slots) master
M: d72136717c01e825ee0df037973b2989cb7686d1 172.22.0.4:6379
   slots:[10923-16383] (5461 slots) master
S: fdb525c6e59acb25c71b10c643c7a930dcecc47b 172.22.0.7:6379
   replicates d72136717c01e825ee0df037973b2989cb7686d1
S: 5356ee3b994b84d83538b02a27a538305bd92413 172.22.0.5:6379
   replicates b054cd8ec15e7fbf8b5ea5537405735e17ae8129
S: cb301e29ea9ec76cd8877d00bd2122dbb6600683 172.22.0.3:6379
   replicates 2eebd2c8af7c6d13be13d131b78420c22c8eb888
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join

>>> Performing Cluster Check (using node 172.22.0.2:6379)
M: b054cd8ec15e7fbf8b5ea5537405735e17ae8129 172.22.0.2:6379
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: 5356ee3b994b84d83538b02a27a538305bd92413 redis-slave-2:6379
   slots: (0 slots) slave
   replicates b054cd8ec15e7fbf8b5ea5537405735e17ae8129
S: cb301e29ea9ec76cd8877d00bd2122dbb6600683 redis-slave-3:6379
   slots: (0 slots) slave
   replicates 2eebd2c8af7c6d13be13d131b78420c22c8eb888
M: 2eebd2c8af7c6d13be13d131b78420c22c8eb888 redis-master-2:6379
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: fdb525c6e59acb25c71b10c643c7a930dcecc47b redis-slave-1:6379
   slots: (0 slots) slave
   replicates d72136717c01e825ee0df037973b2989cb7686d1
M: d72136717c01e825ee0df037973b2989cb7686d1 redis-master-3:6379
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```