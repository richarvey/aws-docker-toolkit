## AWS Toolkit

This is dockerised version of the awscli, which means you can run the tool without directly installing on your system. Its simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type aws in the command line. The image is auto built twice daily to ensure the linux base image is constanstly updated in the background and that you have the latest awscli version. There are two versions of the toolkit the full one (:latest or :2.x.x) which is about ~178Mb or the slim version (:slim or :2.x.x-slim) which is ~107Mb and only includes the awscli with no acess to the help docs (be warned)! At this time slim is only available on amd64 until I fix the build script.

### Why does this version exist?

Amazon provide a container for this already, its good but it weighed in a little heavy for me at ~281MB. I wanted this as small as possibe and managed to shave off 102MB on the uncompressed image. Why else? Well I've been doing this since version 1.6.x and I trust my image builds, I know they are lightweight and no bloat. Latest is based on debian:buster-slim and slim is based on busybox:latest.

The build pipeline for these containers is also passed through [clair](https://github.com/quay/clair) to scan for CVE issues before being published. So these images are tested to be secure.

## Downloading

```
docker pull richarvey/awscli:latest
```

See all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

## Running the toolkit in normal mode
Running in the normal mode gives the CLI tools access to your current working directory and your AWS credentials (potentially ~/.aws). Its controlled by specifying _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ on the command line. This will be the mode used in all the examples. This is great for limiting the reach of the toolkit onto your system. You'll share your AWS credentials and the current working directory so you can use the cloudformation file you've been working on or tell S3 to upload/download files.

## Running the toolkit in open mode
To give you more access to files ouside your current working directory you can swap _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ for ___-v ~/:/home/awsuser___. This give docker access to your entire home directory including your docker credentials.

__NOTE:__ I recommend running these as bash alias' in order to make its a smooth process of using this toolkit.

#### Using the cli

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest ${COMMAND}
```

Alternatively if you don't need the help files and want a super lightweight version:

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:slim ${COMMAND}
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

__NOTE:__ to use the slim version swap _awscli:latest_ for _awscli:slim_

## Building yourself

First pull the latest tags for the awscli and aws-shell. You can do this by simply running the command:

```
./get-tags.sh
```

Now you can build by running:

```
docker build -t MYBUILD .
```

__NOTE:__ _./build.sh_ uses dockers _buildx_ to build amd64 and aarch64 and push to my repo so you'll need to tweak it for your username
