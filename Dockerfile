FROM python:3.9-alpine AS installer

RUN apk add --no-cache \
    gcc \
    git \
    libc-dev \
    libffi-dev \
    openssl-dev \
    py3-pip \
    zlib-dev \
    make \
    openssl \
    perl \
    libunwind-dev \
    bash \
    curl \
    jq \
    cmake

COPY get_tags.sh /get_tags.sh
RUN /get_tags.sh && export AWSCLI_VERSION=`cat releases | head -1` && git clone --recursive  --depth 1 --branch ${AWSCLI_VERSION} --single-branch https://github.com/aws/aws-cli.git

WORKDIR /aws-cli

# Follow https://github.com/six8/pyinstaller-alpine to install pyinstaller on alpine
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pycrypto \
    && git clone --depth 1 --single-branch --branch v$(grep PyInstaller requirements-build.txt | cut -d'=' -f3) https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all \
    && pip install .. \
    && rm -Rf /tmp/pyinstaller \
    && cd - \
    && boto_ver=$(grep botocore setup.cfg | cut -d'=' -f3) \
    && git clone --single-branch --branch v2 https://github.com/boto/botocore /tmp/botocore \
    && cd /tmp/botocore \
    && git checkout $(git log --grep $boto_ver --pretty=format:"%h") \
    && sed -i 's/0.12.4/0.13.3/' setup.py \
    && sed -i 's/0.12.4/0.13.3/' setup.cfg \
    && pip install . \
    && rm -Rf /tmp/botocore  \
    && cd -

RUN sed -i '/botocore/d' requirements.txt \
    && scripts/installers/make-exe

RUN unzip dist/awscli-exe.zip \
    && ./aws/install --bin-dir /aws-cli-bin

FROM alpine:3
LABEL maintainer=“ric@digilution.io”

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
