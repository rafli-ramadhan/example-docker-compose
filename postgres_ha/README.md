## Running

1. Execute

```bash
- /master/Dockerfile
FROM postgres:14

COPY init.sql /docker-entrypoint-initdb.d/

- /master/init.sql
CREATE ROLE replicator WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'replicator_password';

- /master/pg_hba.conf
# Allow replication connections from anywhere (untuk DEV, nanti produksi perketat subnet)
host    replication     replicator      0.0.0.0/0       md5
host    replication     replicator      172.26.0.0/16   md5

# Allow normal connections dari mana saja pakai password
host    all             all             0.0.0.0/0       md5

- /master/postgresql.conf
wal_level = replica
max_wal_senders = 10
wal_keep_size = 64MB
listen_addresses = '*'

- /slave/Dockerfile
FROM postgres:14

COPY setup-replica.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/setup-replica.sh

- /slave/setup-replica.sh
#!/bin/bash
set -e

echo "Waiting for master to be ready..."
until pg_isready -h postgres-master -U postgres; do
  sleep 2
done

echo "Stopping PostgreSQL temporarily..."
pg_ctl -D "$PGDATA" -m fast stop

echo "Cleaning up old data directory..."
rm -rf "$PGDATA"/*

echo "Cloning data from master using pg_basebackup..."
PGPASSWORD=replicatorpass pg_basebackup -h postgres-master -D "$PGDATA" -U replicator -Fp -Xs -P -R

echo "Replication setup complete."

- docker-compose.yaml
version: '3.8'

services:
  postgres-master:
    build: ./master
    container_name: postgres-master
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - pg-master-data:/var/lib/postgresql/data
      - ./master/pg_hba.conf:/etc/postgresql/pg_hba.conf
      - ./master/postgresql.conf:/etc/postgresql/postgresql.conf
    networks:
      - postgres-net
    restart: unless-stopped

  postgres-slave:
    build: ./slave
    container_name: postgres-slave
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports:
      - "5433:5432"
    depends_on:
      - postgres-master
    volumes:
      - pg-slave-data:/var/lib/postgresql/data
    networks:
      - postgres-net
    restart: unless-stopped

volumes:
  pg-master-data:
  pg-slave-data:

networks:
  postgres-net:
    driver: bridge

```