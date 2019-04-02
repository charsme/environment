FROM ubuntu:18.10

ENV DATA_DIR /data

RUN apt-get update -q -y \
    && apt-get -q -y install beanstalkd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && mkdir -p $DATA_DIR

EXPOSE 11300
ENTRYPOINT ["/usr/bin/beanstalkd"]
