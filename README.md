## AWS Toolkit - [![build](https://github.com/richarvey/aws-docker-toolkit/actions/workflows/main.yml/badge.svg)](https://github.com/richarvey/aws-docker-toolkit/actions/workflows/main.yml) ![docker pulls](https://img.shields.io/docker/pulls/richarvey/awscli) ![docker version](https://img.shields.io/docker/v/richarvey/awscli?sort=semver)

This is dockerized version of the awscli, which means you can run the tool without directly installing it on your system. It's simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type ```aws``` in the command line. The image is auto-built daily to ensure the Linux base image is constantly updated in the background and that you have the latest awscli version.

I've finally made a unified version which is super slim and from version ```2.2.10``` it's a mere 97.6Mb and is based upon alpine Linux (yes all the musl libc and OpenSSL issues are taken care of) add to this it is available on both x86_64 and arm64.

Tags and releases are in line with the AWS CLI version, so you can use that to pull a specific release if needed for example: ```2.2.6```
### Why does this version exist?

Amazon provides a container for this already, it's good but it weighed in a little heavy for me at ~387MB. I wanted this as small as possible and managed to shave off ~290MB on the uncompressed image.

|Image                | Version         | Base         | Size (uncomnpressed) | Size (compressed) |
|---------------------|-----------------|--------------|----------------------|-------------------|
| amazon/aws-cli      | latest          | amazon linux | 387MB                | ![image size](https://img.shields.io/docker/image-size/amazon/aws-cli)          |
| richarvey/awscli    | < 2.2.9+        | debian slim  | ~178MB               | ![image size](https://img.shields.io/docker/image-size/richarvey/awscli/2.2.9)  |       
| richarvey/awscli    | 2.2.10+         | alpine linux | 97.6MB               | ![image size](https://img.shields.io/docker/image-size/richarvey/awscli/2.2.10) |       
| richarvey/awscli    | 2.3.0+          | alpine linux | ~113MB               | ![image size](https://img.shields.io/docker/image-size/richarvey/awscli/2.3.0)  |       
| richarvey/awscli    | latest          | alpine linux | ~143MB               | ![image size](https://img.shields.io/docker/image-size/richarvey/awscli)        |       


__Why else?__

Well, I've been doing this since version 1.6.x and I trust my image builds, I know they are lightweight and no bloat. Switching from debian-slim to Alpine Linux has allowed me to make this even smaller so I'm super happy with that. 

## Downloading

```
docker pull richarvey/awscli:latest
```

See all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

## Running the toolkit in normal mode
Running in the normal mode gives the CLI tools access to your current working directory and your AWS credentials (potentially ~/.aws). Its controlled by specifying _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ on the command line. This will be the mode used in all the examples. This is great for limiting the reach of the toolkit onto your system. You'll share your AWS credentials and the current working directory so you can use the CloudFormation file you've been working on or tell S3 to upload/download files.

## Running the toolkit in open mode
To give you more access to files outside your current working directory you can swap _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ for ___-v ~/:/home/awsuser___. This gives docker access to your entire home directory including your docker credentials.

__NOTE:__ I recommend running these as bash alias' in order to make it a smooth process of using this toolkit and save a lot of typing.

#### Using the cli

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest ${COMMAND}
```

## Adding to .bash_profile for :latest

You can set an alias and then use awscli as normal from your shell if desired, this makes it super easy to access.

```
vi ~/.bash_profile
```

```
aws() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest "$@";
}
```

Now when you call ```aws``` from the command line (don't forget to source your bash_profile) you'll have direct access to the aws command as if it were installed on your system. 

## Building yourself

The build process is now super simple and you can build using the normal docker tools:

```
docker build -t MYBUILD .
```
