## AWS Toolkit ![pipeline status](https://gitlab.com/ric_harvey/docker-aws-toolkit/badges/master/pipeline.svg)

Dockerised version of awscli, aws-shell and aws-cdk which means you can run the tools without directly installing on your system. Its simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type aws in the command line. The image is autobuilt twice daily to ensure alpine linux is constanstly updated in the background and that you have the latest awscli version. There are two versions of the toolkit the full one (:latest or :1.xx.xx) which is about ~92Mb or the slim version (:slim or :1.xx.xx-slim) which is ~42Mb and only includes the aws cli.

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

#### signed_url

Its sometimes useful to be able to generate signed URL's fromt he command line so I've installed a small script that can do just that. Just pass it your details and it will return a signed_url, the default time expiry time is 5 mins (300 seconds).

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest /usr/bin/signed_url

usage: signed_url [-h] -b BUCKET -o OBJECT [-t TIME]
signed_url: error: the following arguments are required: -b/--bucket, -o/--object
```

#### Upgrading

Install the bash_profile and run the command:

```
aws_update latest
```

or

```
aws_update slim
```

## Adding to .bash_profile for :latest

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

signed_url() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest signed_url "$@";
}

aws_update() {
  export FLAVOUR=$1
  export VERSION=`docker run richarvey/awscli:latest cat /version`
  export CURRENT=`curl -s https://gitlab.com/api/v4/projects/11226436/repository/tags/ | jq .[0].name | sed -e s/\"//g`

  if [ ${VERSION} == ${CURRENT} ]; then
    echo "AWS CLI upto date"
  else
    echo "Updating AWS CLI"
    docker rmi -f richarvey/awscli:${FLAVOUR}
    docker pull richarvey/awscli:${FLAVOUR}
  fi
}
```

## Adding to .bash_profile for :slim

You'll just need thetwo commands if you are using the slim version

```
aws() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest aws "$@";
}

aws_update() {
  export FLAVOUR=$1
  export VERSION=`docker run richarvey/awscli:latest cat /version`
  export CURRENT=`curl -s https://gitlab.com/api/v4/projects/11226436/repository/tags/ | jq .[0].name | sed -e s/\"//g`

  if [ ${VERSION} == ${CURRENT} ]; then
    echo "AWS CLI upto date"
  else
    echo "Updating AWS CLI"
    docker rmi -f richarvey/awscli:${FLAVOUR}
    docker pull richarvey/awscli:${FLAVOUR}
  fi
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


