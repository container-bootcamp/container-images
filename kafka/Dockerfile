FROM ches/kafka:0.10.2.0

ADD server.properties.template /kafka/config/server.properties.template
USER root
ADD start-with-topics.sh /start-with-topics.sh
ADD create-topics.sh /create-topics.sh
ADD kafka-0-8-2.yml /kafka-0-8-2.yml
RUN wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.9/jmx_prometheus_javaagent-0.9.jar \
          -O /jmx_prometheus_javaagent-0.9.jar
RUN chmod 755 /start-with-topics.sh /create-topics.sh

ENV KAFKA_OPTS -javaagent:/jmx_prometheus_javaagent-0.9.jar=7071:/kafka-0-8-2.yml
ENV KAFKA_HEAP_OPTS -Xmx512m -Xms256M
ENV LOG_DIR /logs

CMD ["/start-with-topics.sh"]
