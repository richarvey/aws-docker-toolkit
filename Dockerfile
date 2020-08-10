FROM debian:buster as build
LABEL maintainer="ric@ngd.io"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    groff \
    less \
    curl \
    unzip

RUN ARCH=`uname -m` && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --bin-dir /aws-cli-bin && \
    mkdir /cfg

# Now copy it into our base image.
FROM debian:buster-slim

# Copy less and groff
COPY --from=build /usr/lib/groff  /usr/lib/groff
COPY --from=build /usr/share/groff /usr/share/groff
COPY --from=build /usr/bin/groff /usr/bin/groff
COPY --from=build /etc/groff /etc/groff
COPY --from=build /usr/bin/grotty /usr/bin/grotty
COPY --from=build /usr/bin/troff /usr/bin/troff
COPY --from=build /usr/lib/mime/packages/less /usr/lib/mime/packages/less
COPY --from=build /usr/bin/less /usr/bin/less

# Copy aws tooling and directories

COPY --from=build /usr/local/aws-cli /usr/local/aws-cli
COPY --from=build /aws-cli-bin /usr/local/bin
COPY --from=build /cfg /cfg

RUN adduser -u 1000 awsuser && \
    aws --version > /version

WORKDIR /cfg
ENV HOME=/home/awsuser
USER awsuser

ENTRYPOINT ["/usr/local/bin/aws"]

