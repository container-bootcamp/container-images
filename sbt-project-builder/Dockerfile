FROM debian:stretch-slim

ENV SCALA_VERSION 2.12.4
ENV SBT_VERSION 1.0.3
ENV JAVA_MAIN_VERSION 8
ENV JAVA_MINOR_VERSION 152
ENV JAVA_VERSION ${JAVA_MAIN_VERSION}u${JAVA_MINOR_VERSION}
ENV JAVA_BUILD_VERSION b16
ENV JAVA_DOWNLOAD_IDENTIFIER aa0333dd3019491ca4f6ddbe78cdb6d0
ENV JAVA_HOME /opt/jdk1.${JAVA_MAIN_VERSION}.0_${JAVA_MINOR_VERSION}


ENV PATH /opt/jdk1.${JAVA_MAIN_VERSION}.0_${JAVA_MINOR_VERSION}/bin:/opt/sbt/bin:/opt/scala-${SCALA_VERSION}/bin:$PATH

ENV SBT_OPTS -Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M -Duser.timezone=GMT

RUN mkdir /sbt-project

## prepare debian to install docker, sbt, scala and java
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 && \
    apt-key del 58118E89F3A912897C070ADBF76221572C52609D && \
    apt-get purge apt-transport-https ca-certificates && \
    apt-get clean && \
    apt-get autoremove && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates dirmngr && \
    apt-key adv \
        --keyserver hkp://ha.pool.sks-keyservers.net:80 \
        --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo debian-stretch main" | tee /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends \
		bc \
		bzip2 \
        unzip \
        xz-utils \
        wget \
        docker-engine && \
	 rm -rf /var/lib/apt/lists/*

# add repo for the docker packages
RUN echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list

## install sbt, scala and java
RUN wget \
    -qO - \
    "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar xvfz - -C /opt/ && \
    wget -qO - \
    "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" | tar xvfz - -C /opt/ && \
    wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-${JAVA_BUILD_VERSION}/${JAVA_DOWNLOAD_IDENTIFIER}/jdk-${JAVA_VERSION}-linux-x64.tar.gz" \
    -qO - | tar xvfz - -C /opt

# set bash stuff
ENV BASH_PATH "export PATH=/opt/jdk1.${JAVA_MAIN_VERSION}.0_${JAVA_MINOR_VERSION}/bin:/opt/sbt/bin:/opt/scala-${SCALA_VERSION}/bin:$PATH"
ENV BASH_JAVA_HOME "export JAVA_HOME=${JAVA_HOME}"
RUN echo "${BASH_PATH}\n${BASH_JAVA_HOME}" >> /root/.bashrc

## Download install basic sbt libraries and test java installed
RUN sbt version

VOLUME /sbt-project





