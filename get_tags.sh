#!/bin/bash
  echo "Getting all releases"
  curl https://api.github.com/repos/aws/aws-cli/tags | jq -r .[].name | grep -v dev > releases
  cat releases | head -n1 > latest

