FROM alpine:latest
MAINTAINER ric@ngd.io

ARG CLI_VERSION
ARG SHELL_VERSION

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --update \
    groff \
    less \
    bash \
    python3 && \
    pip3 install --upgrade pip && \
    adduser -D -u 1000 awsuser && \
    pip3 install awscli==${CLI_VERSION} && \
    pip3 install aws-shell==${SHELL_VERSION} && \
    pip3 install boto && \
    pip3 install boto3

WORKDIR /cfg
ENV HOME=/home/awsuser
USER awsuser

CMD ["/usr/bin/aws"]
