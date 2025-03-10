#!/usr/bin/env bash
PWD=`pwd`
PROJECT=$PWD
GO=go
case $1 in
  install)
    sudo apt-get update
    sudo apt-get install build-essential gcc cmake -y
    sudo curl -LO https://go.dev/dl/go1.23.3.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz && sudo rm go*.linux-amd64.tar.gz
    cd tools && python3 -m pip install -r requirements.txt
    ;;
  ggml)
  #deepseek
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00001-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00002-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00003-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00004-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00005-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00006-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00007-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00008-of-00009.gguf
    wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-00009-of-00009.gguf
  #qwq
    wget https://huggingface.co/unsloth/QwQ-32B-GGUF/resolve/main/QwQ-32B.Q8_0.gguf
    ;;
  pdf)
    cd $PROJECT/tools && python parse_html.py
    ;;
  md)
    cd $PROJECT/tools && python pdf_md.py
    ;;
  build)
    cd $PROJECT/llm/cmd && CGO_ENABLED=1 OLLAMA_BACKEND=ggml $GO build -tags="ggml" -o $PROJECT/llmbin
    ;;
  run)
    ./llmbin runner --ollama-engine --port 10000 --model ./ggml
    ;;
  *)
    echo "not support:$1"
    ;;
esac