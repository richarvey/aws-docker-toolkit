FROM python:3.10.10-alpine3.17 AS installer

RUN apk add --no-cache \
        git \
        unzip \
        groff \
        build-base \
        libffi-dev \
        cmake \
        bash \
        curl \
        jq 

COPY get_tags.sh /get_tags.sh
RUN /get_tags.sh && export AWSCLI_VERSION=`cat releases | head -1` && git clone --recursive  --depth 1 --branch ${AWSCLI_VERSION} --single-branch https://github.com/aws/aws-cli.git

WORKDIR /aws-cli

RUN python -m venv venv && \
 . venv/bin/activate && \
 scripts/installers/make-exe && \
 unzip -q dist/awscli-exe.zip && \
 aws/install --bin-dir /aws-cli-bin && \
 /aws-cli-bin/aws --version

# reduce image size: remove autocomplete and examples
RUN rm -rf /usr/local/aws-cli/v2/current/dist/aws_completer /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index /usr/local/aws-cli/v2/current/dist/awscli/examples
RUN find /usr/local/aws-cli/v2/current/dist/awscli/data -name completions-1*.json -delete
RUN find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete


FROM alpine:3
LABEL maintainer=“ric@squarecows.com”

RUN apk add --update --no-cache \
    less \
    groff \
    jq
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/

RUN adduser -D -u 1000 awsuser && \
    aws --version > /version

WORKDIR /cfg
ENV HOME=/home/awsuser
USER awsuser

ENTRYPOINT ["/usr/local/bin/aws"]
