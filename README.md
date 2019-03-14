## AWS Toolkit ![pipeline status](https://gitlab.com/ric_harvey/docker-aws-toolkit/badges/master/pipeline.svg)

Dockerised version of awscli and aws-shell which means you can run the tools without directly installing on your system. Its simple to map your AWS credentials to this container and even set up a __.bash_profile__ so you can just type aws in the command line. The image is autobuilt twice daily to ensure alpine linux is constanstly updated in the background and that you have the latest awscli version. I recomend you use something like docker-puller to keep the image fresh on your machine.

### Downloading

```
docker pull richarvey/awscli:latest
```

see all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

### Running 

#### cli mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest aws ${COMMAND}
```

You can set an alias and then use awscli as normal from your shell if desired:

```
vi ~/.bash_profile
```

```
aws() {
  docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws --rm richarvey/awscli:latest aws "$@";
}
```

#### aws-shell mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest aws-shell
```

#### bash mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:latest bash
```

### Building yourself

First pull the latest tags for the awscli and aws-shell. You can do this by simply running the command:

```
./get-tags.sh
```

Now you can build by running:

```
export VERSION=`cat latest`
export SHELL_VERSION=`cat shell-latest`

docker build --build-arg CLI_VERSION="${VERSION}" --build-arg SHELL_VERSION="${SHELL_VERSION}" -t "richarvey/awscli:${VERSION}"
``` 
