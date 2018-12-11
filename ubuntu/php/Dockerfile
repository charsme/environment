FROM ubuntu:18.10

RUN apt-get update \
    && apt-get -q -y install beanstalkd \
    && apt-get autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && mkdir -p $DATA_DIR

EXPOSE 11300
ENTRYPOINT ["/usr/bin/beanstalkd"]
