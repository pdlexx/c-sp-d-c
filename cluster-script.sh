#!/bin/bash

#define var
replicas=$1
casram=$2
cascpu=$3
sparkram=$4
sparkcpu=$5

#show expected result in terminal
echo "cluster generate with $replicas Cassandra replicas with $cascpu CPU and $casram of RAM"
echo "cluster generate with $replicas Spark replicas with $sparkcpu CPU and $sparkram of RAM"

#generating file
i=$replicas

#insert initial conf
cat templates/start.yml > docker-compose.yml

#insert spark - master service
cat templates/spark-m.yml >> docker-compose.yml

#insert spark - worker services
while [ "$i" -ge 1 ]
do
    echo > sparktemp*.yml
    cat templates/spark-w.yml | sed "s/9091:/909$i:/" >> sparktemp.yml
    cat sparktemp.yml | sed "s/7001:7001/700$i:700$i/" >> sparktemp1.yml
    cat sparktemp1.yml | sed "s/SPARK_WORKER_CORES=1/SPARK_WORKER_CORES=$sparkcpu/" >> sparktemp2.yml
    cat sparktemp2.yml | sed "s/SPARK_WORKER_MEMORY=1G/SPARK_WORKER_MEMORY="$sparkram"G/" >> sparktemp3.yml
    cat sparktemp3.yml | sed "s/spark-worker-1/spark-worker-$i/" >> docker-compose.yml
    rm sparktemp*.yml
    i=$((i-1))
done

#insert additional infra for spark
cat templates/infra.yml >> docker-compose.yml

i=$replicas

#insert cassandra - seed service
cat templates/cassandra-m.yml >> docker-compose.yml

#insert cassandra - wrk svc
while [ "$i" -ge 1 ]
do
    echo > castemp*.yml
    cat templates/cassandra-w.yml | sed "s/cassandra1/cassandra$i/" >> castemp.yml
    cat castemp.yml | sed "s/cpus: '1'/cpus: '$cascpu'/" >> castemp1.yml
    cat castemp1.yml | sed "s/memory: 50M/memory: "$casram"G/" >> castemp2.yml
    cat castemp2.yml | sed "s/cassandra_data_1/cassandra_data_$i/" >> docker-compose.yml
    rm castemp*.yml
    i=$((i-1))
done

i=$replicas

#insert cassandra volumes conf

cat templates/cassandra-vol.yml > cvtemp.yml

while [ "$i" -ge 1 ]
do
    echo "  cassandra_data_$i:" >> cvtemp.yml
    i=$((i-1))
done

cat cvtemp.yml >> docker-compose.yml
rm cvtemp.yml

#end of script to terminal
echo 'docker-compose.yml generated'

exit 0