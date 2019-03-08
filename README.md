## AWS Toolkit

Dockerised version of awscli and aws-shell, images are built using latest alpine base to make this a lightweight tool kit to run aws tools.

### Downloading

Pick a version you want to download for example 1.16.121

```
docker pull richarvey/awscli:1.16.121
```

see all tags at [https://hub.docker.com/r/richarvey/awscli/tags/](https://hub.docker.com/r/richarvey/awscli/tags/)

### Running 

#### cli mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:${VERSION} aws ${COMMAND}
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
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:${VERSION} aws-shell
```

#### bash mode

Run the container and map a local directory (for files you amy want to use) and .aws config for credentials

```
docker run -it -v `pwd`:/cfg -v ~/.aws:/home/awsuser/.aws richarvey/awscli:${VERSION} bash
```

