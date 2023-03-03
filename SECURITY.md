# Security Policy

These images are built with minimal software installed to help ensure a smaller vunerability vector. The installed packages are:

- alpine linux (base image)
- awscli (from source)
- less
- groff
- jq

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| ![docker version](https://img.shields.io/docker/v/richarvey/awscli?sort=semver) | :white_check_mark: |
| previous tags | x |

## Reporting a Vulnerability

If you spot a vulnerability that needs addressing please open an issue and we'll get onto it! Security in these images are top priority. We scan the images both on Github and Dockerhub.
