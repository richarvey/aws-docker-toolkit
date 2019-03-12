#!/bin/bash

export VERSION=`cat latest`
export SHELL_VERSION=`cat shell-latest`
export latest=`curl -Is https://hub.docker.com/v2/repositories/richarvey/awscli/tags/$(cat latest)/ | head -n 1|cut -d$' ' -f2`

if [ ${latest} == "200" ]; then
    echo "Build Exists: Nothing to do!"
    exit 0
else
    echo "Building: awscli"
    docker build --build-arg CLI_VERSION="${VERSION}" --build-arg SHELL_VERSION="${SHELL_VERSION}" -t "richarvey/awscli:${VERSION}" . && \
    docker push "richarvey/awscli:${VERSION}"

    docker tag richarvey/awscli:${VERSION} richarvey/awscli:latest && docker push "richarvey/awscli:latest"

fi
