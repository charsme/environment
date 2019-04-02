FROM alpine:3.9
LABEL maintainer="Abdulloh Charis<me@chars.me>"

RUN apk add --no-cache beanstalkd \
    && mkdir "/var/data"

EXPOSE 11300
ENTRYPOINT ["/usr/bin/beanstalkd"]
