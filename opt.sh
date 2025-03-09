#!/usr/bin/env bash
PWD=`pwd`
PROJECT=$PWD

case $1 in
  install)
    sudo curl -LO https://go.dev/dl/go1.23.3.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz && sudo rm go*.linux-amd64.tar.gz
    ;;
  html)
    cd $PROJECT/tools && python parse_html.py
    ;;
  build)
    cd $PROJECT/llm/cmd && CGO_ENABLED=1 go build -tags="ggml" -o $PROJECT/bin/llm
    ;;
  *)
    echo "not support:$1"
    ;;
esac