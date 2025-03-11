#!/usr/bin/env bash
PWD=`pwd`
PROJECT=$PWD
GO=go
case $1 in
  no)
  sudo mkfs.ext4 /dev/nvme2n1
  sudo mkfs.ext4 /dev/nvme1n1
  sudo pvcreate /dev/nvme1n1
  sudo pvcreate /dev/nvme2n1
  sudo vgcreate vg_root /dev/nvme1n1

  sudo vgextend vg-root /dev/nvme1n1
  sudo vgextend vg-root /dev/nvme2n1
  sudo lvextend -l +100%FREE /dev/vg-root/lv-root
  sudo resize2fs /dev/vg-root/lv-root




  curl -X POST 127.0.0.1:11434/api/pull -d '{"model":"qwq:32b"}'
  curl -X GET 127.0.0.1:11434/v1/models

  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-12-6
nvidia-smi
/usr/local/cuda-12.6/extras/demo_suite/deviceQuery

   curl -fsSL https://ollama.com/install.sh | sh
# Environment="CUDA_VISIBLE_DEVICES=0"
# Environment="OLLAMA_SCHED_SPREAD=1"
# Environment="OLLAMA_NUM_PARALLEL=2"
# Environment="OLLAMA_HOST=0.0.0.0"
# Environment="OLLAMA_PORT=11434"
    #sudo vim /etc/systemd/system/ollama.service
    #sudo systemctl daemon-reload
    #sudo service ollama restart
        sudo apt-get install ollama -y
        ollama pull qwq:32b
        ollama run qwq:32b
        
   /usr/local/bin/ollama runner --model /usr/share/ollama/.ollama/models/blobs/sha256-c62ccde5630c20c8a9cf601861d31977d07450cad6dfdf1c661aab307107bddb --ctx-size 4096 --batch-size 512 --n-gpu-layers 65 --threads 16 --parallel 2 --port 44791
  ;;
  install)
    sudo apt-get update
    sudo apt-get install build-essential gcc cmake -y
    sudo curl -LO https://go.dev/dl/go1.23.3.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz && sudo rm go*.linux-amd64.tar.gz
    cd tools && python3 -m pip install -r requirements.txt
    sudo apt install python3-pip
    sudo apt install python3.12-venv
    python3 -m venv py
    source ./py/bin/activate
    ;;
  init_oa)
  git clone https://github.com/ollama/ollama.git
  cd ollama && go build
  ;;
  start_oa)
  cd ollama && ./ollama serve
  ;;
  chat_oa)
  curl http://localhost:11434/api/chat -d '{
    "model": "qwq:32b",
    "messages": [
      {
        "role": "user",
        "content": "你会做点什么呢"
      }
    ],
    "stream": true
  }'
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
    ./llmbin runner --ollama-engine --port 10000 --model $2 --flash-attn true
    ;;
  *)
    echo "not support:$1"
    ;;
esac