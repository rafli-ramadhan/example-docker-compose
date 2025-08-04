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
