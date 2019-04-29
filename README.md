## AWS Toolkit ![pipeline status](https://gitlab.com/ric_harvey/docker-aws-toolkit/badges/master/pipeline.svg)

Dockerised version of awscli, aws-shell and aws-cdk which means you can run the tools without directly installing on your system. Its simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type aws in the command line. The image is autobuilt twice daily to ensure alpine linux is constanstly updated in the background and that you have the latest awscli version.

I highly recomend you install the commands to __.bash_profile__ for ease of use.

## Downloading

```
docker pull richarvey/awscli:latest
```

see all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

## Running the toolkit in sandbox mode
Running in sandbox mode gives the CLI tools access to your current workign directory and your AWS credentials (potentially ~/.aws). Its controlled by specifying _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ on the command line. This will be the mode used in all the examples.

## Running the toolkit in open mode
To give you more access to files ouside your current working directory you can swap _-v \`pwd\`:/cfg -v ~/.aws:/home/awsuser/.aws_ for ___-v ~/:/home/awsuser___. This give docker access to your entire home directory including your docker credentials. _NOTE:_ I recommend running these as bash alias' in order to make its a smooth process of using this toolkit.

#### Using the cli

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest aws ${COMMAND}
```

Alternatively if you don't need the shell, CDK or bash mode and are happy with just the CLI there is a slim image:

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:slim aws ${COMMAND}
```

#### Using aws-shell

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest aws-shell
```

#### Using aws-cdk

Run the container and map a local directory (for files you may want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest cdk
```

#### bash mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest bash
```


## Adding to .bash_profile

You can set an alias and then use awscli as normal from your shell if desired, this makes it super easy to access.

```
vi ~/.bash_profile
```

```
aws() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest aws "$@";
}

aws-shell() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest aws-shell "$@";
}

cdk() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest cdk "$@";
}

```


## Building yourself

First pull the latest tags for the awscli and aws-shell. You can do this by simply running the command:

```
./get-tags.sh
```

Now you can build by running:

```
./build.sh
``` 
