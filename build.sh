#!/bin/bash

export VERSION=`cat latest`
export SHELL_VERSION=`cat shell-latest`
export CDK_VERSION=`cat cdk-latest`
export latest=`curl -Is https://hub.docker.com/v2/repositories/richarvey/awscli/tags/$(cat latest)/ | head -n 1|cut -d$' ' -f2`

if [ ${latest} == "200" ]; then
    echo "Build Exists: Nothing to do!"
    exit 0
else
    echo "Building: awscli"
#    docker build --build-arg CLI_VERSION="${VERSION}" --build-arg SHELL_VERSION="${SHELL_VERSION}" --build-arg CDK_VERSION="${CDK_VERSION}" -t "richarvey/awscli:${VERSION}" . && \ 
#    docker push "richarvey/awscli:${VERSION}"

    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg CLI_VERSION="${VERSION}" --build-arg SHELL_VERSION="${SHELL_VERSION}" --build-arg CDK_VERSION="${CDK_VERSION}" -t richarvey/awscli:latest --push .

    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg CLI_VERSION="${VERSION}" --build-arg SHELL_VERSION="${SHELL_VERSION}" --build-arg CDK_VERSION="${CDK_VERSION}" -t richarvey/awscli:${VERSION} --push .

    #docker tag richarvey/awscli:${VERSION} richarvey/awscli:latest && docker push "richarvey/awscli:latest"

# Build Slim
#    echo "Building: awscli:slim"
#    docker build --build-arg CLI_VERSION="${VERSION}" -t "richarvey/awscli:${VERSION}-slim" -f Dockerfile-slim . && \
#    docker push "richarvey/awscli:${VERSION}-slim"

#    docker tag richarvey/awscli:${VERSION}-slim richarvey/awscli:slim && docker push "richarvey/awscli:slim"

    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg CLI_VERSION="${VERSION}" -t richarvey/awscli:slim --push .

    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg CLI_VERSION="${VERSION}" -t richarvey/awscli:${VERSION}slim --push .

fi
