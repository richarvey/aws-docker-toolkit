#!/bin/bash
  echo "Getting all releases"
  curl https://api.github.com/repos/aws/aws-cli/tags | jq -r .[].name > releases
  curl https://api.github.com/repos/aws/aws-cli/tags | jq -r .[].name | head -n1 > latest

  curl https://api.github.com/repos/awslabs/aws-shell/tags | jq -r .[].name | grep -v reinvent-demo > shell-releases
  curl https://api.github.com/repos/awslabs/aws-shell/tags | jq -r .[].name | grep -v reinvent-demo | head -n1 > shell-latest
