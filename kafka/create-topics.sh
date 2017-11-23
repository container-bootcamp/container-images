#!/bin/bash
# creates topics provided from env-var
# taken from https://github.com/wurstmeister/kafka-docker

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=0.1

while netstat -lnt | awk '$4 ~ /:'$KAFKA_PORT'$/ {exit 1}'; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$(expr $count + 1)
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Not able to auto-create topic (waited for $START_TIMEOUT sec)"
    exit 1
fi

[ -z "$ZOOKEEPER_CONNECTION_STRING" ] && ZOOKEEPER_CONNECTION_STRING="${ZOOKEEPER_IP}:${ZOOKEEPER_PORT:-2181}"

if [[ -n $KAFKA_CREATE_TOPICS ]]; then
    IFS=','; for topicToCreate in $KAFKA_CREATE_TOPICS; do

        result=1

        while [[ result -ne 0 ]]; do
            echo "creating topics: $topicToCreate"
            IFS=':' read -a topicConfig <<< "$topicToCreate"
            JMX_PORT='' KAFKA_OPTS='' /kafka/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_CONNECTION_STRING --replication-factor ${topicConfig[2]} --partition ${topicConfig[1]} --topic "${topicConfig[0]}" --if-not-exists

            result=$?

            if [[ result -eq 0 ]]; then
                echo "Created topic: $topicToCreate"
            else
                echo "Did not create topic: $topicToCreate, retrying"
            fi
        done
    done
fi
