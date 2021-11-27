# Spark & Cassandra Clusters with docker-compose

# General

Standalone cluster for testing.

The Docker compose will create the following containers:

spark-master
spark-worker-X
demo-database
cassandra-seed
cassandraX

# Installation

## Pre requisites

* Docker installed

* Docker compose  installed

## Build the image with proper version (3.0.0) of Spark (not found in dockerhub)

```sh
docker build -t cluster-apache-spark:3.0.0 .
```

## Generate docker-compose.yaml:

# Specify inputs of the script:
# $1 - worker replicas of Cassandra & Spark (9 max)
# $2 - limits of Cassandra worker memory GB
# $3 - limits of Cassandra worker CPUs
# $4 - spark worker memory GB
# $5 - spark worker cores

```sh
cluster-script.sh 1 2 3 4 5
```


## Run the docker-compose

The final step to create your test cluster will be to run the compose file:

```sh
docker-compose up -d
```

## Validate cluster

## Spark Master

http://localhost:9090/

## Cassandra

docker ps
docker exec test_cassandra-seed_1  nodetool status


# Why a standalone cluster?

* This is intended to be used only for test purposes.
