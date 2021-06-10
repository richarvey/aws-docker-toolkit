## AWS Toolkit  -  [![CI](https://github.com/WAOptics/aws-docker-toolkit/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/WAOptics/aws-docker-toolkit/actions/workflows/main.yml) [![scan](https://github.com/WAOptics/aws-docker-toolkit/actions/workflows/trivy-analysis.yml/badge.svg?branch=main)](https://github.com/WAOptics/aws-docker-toolkit/actions/workflows/trivy-analysis.yml)

This is dockerised version of the awscli, which means you can run the tool without directly installing on your system. Its simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type ```aws``` in the command line. The image is auto built daily to ensure the linux base image is constanstly updated in the background and that you have the latest awscli version.

I've finally made a unified version which is super slim and from version ```2.2.10``` it's a mere 97.6Mb and is based upon alpine linux (yes all the musl libc and openssl issues are taken care of) add to this it is available on both x86_64 and arm64.

Tags and releases are inline with the AWS CLI version, so you can use that to pull a specific release if needed for example: ```2.2.6```

### Why does this version exist?

Amazon provide a container for this already, its good but it weighed in a little heavy for me at ~387MB. I wanted this as small as possibe and managed to shave off ~290MB on the uncompressed image.

|Image                | Version         | Base         | Size (uncomnpressed) |
|---------------------|-----------------|--------------|----------------------|
| amazon/aws-cli      | latest          | amazon linux | 387Mb                |
| richarvey/awscli    | latest,2.2.10+  | alpine linux | 97.6Mb               |        

**Why else?**

Well I've been doing this since version 1.6.x and I trust my image builds, I know they are lightweight and no bloat. switching from debian-slim to linux has allowed me to make this even smaller so I'm super happy with that. 

## Downloading

```bash
docker pull richarvey/awscli:latest
```

See all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

## Running the toolkit in normal mode
Running in the normal mode gives the CLI tools access to your current working directory and your AWS credentials (potentially ~/.aws). Its controlled by specifying _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ on the command line. This will be the mode used in all the examples. This is great for limiting the reach of the toolkit onto your system. You'll share your AWS credentials and the current working directory so you can use the cloudformation file you've been working on or tell S3 to upload/download files.

## Running the toolkit in open mode
To give you more access to files ouside your current working directory you can swap _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ for ___-v ~/:/home/awsuser___. This give docker access to your entire home directory including your docker credentials.

__NOTE:__ I recommend running these as bash alias' in order to make its a smooth process of using this toolkit and save a lot of typing.

#### Using the cli

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```bash
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest ${COMMAND}
```

## Adding to .bash_profile for :latest

You can set an alias and then use awscli as normal from your shell if desired, this makes it super easy to access.

```bash
vi ~/.bash_profile
```

```bash
aws() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest "$@";
}
```

Now when you call ```aws``` from the command line (don't forget to source your bash_profile) you'll have direct access to the aws comand as if it were installed on your system. 

## Building yourself

The build process is now super simple and you can build using the normal docker tools:

```bash
docker build -t MYBUILD .
```
