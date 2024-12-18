#!/bin/bash
set -eu

# The TRELLIS demo was written in Linux context in mind. So here we use bash to run it.
# You need to install <Git for Windows> with <Git Bash> (installed by default).
# Download: https://git-scm.com/download/win

################################################################################
# Edit this first! According to your GPU model.
export TORCH_CUDA_ARCH_LIST="6.1+PTX"

# "flash-attn" can ONLY be used on Ampere and later GPUs (RTX 30 series and beyond).
# Change it to "xformers" if you can't start the program.
export ATTN_BACKEND="flash-attn"

# "auto" will be faster but will do benchmarking at the beginning.
# If run only once, set to "native".
export SPCONV_ALGO="auto"


################################################################################

# To set proxy, edit and uncomment the lines below
# (remove '#' in the beginning of line).
#export HTTP_PROXY=http://localhost:1081
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#export NO_PROXY="localhost,*.local,*.internal,[::1],fd00::/7,
#10.0.0.0/8,127.0.0.0/8,169.254.0.0/16,172.16.0.0/12,192.168.0.0/16,
#10.*,127.*,169.254.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,
#172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,
#172.28.*,172.29.*,172.30.*,172.31.*,172.32.*,192.168.*,
#*.cn,ghproxy.com,*.ghproxy.com,ghproxy.org,*.ghproxy.org,
#gh-proxy.com,*.gh-proxy.com,ghproxy.net,*.ghproxy.net"
#export no_proxy=$NO_PROXY
#echo "[INFO] Proxy set to $HTTP_PROXY"

# To set mirror site for PIP & HuggingFace Hub, uncomment and edit the two lines below.
#export PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
#export HF_ENDPOINT="https://hf-mirror.com"

# To set HuggingFace Access Token, uncomment and edit the line below.
# https://huggingface.co/settings/tokens
#export HF_TOKEN=

# To enable HuggingFace Hub's experimental high-speed file transfer, uncomment the line below.
# https://huggingface.co/docs/huggingface_hub/hf_transfer
#export HF_HUB_ENABLE_HF_TRANSFER=1

workdir="$(pwd)"

# This command redirects HuggingFace-Hub to download model files in this folder.
export HF_HUB_CACHE="$workdir/HuggingFaceHub"

# This command will set PATH environment variable.
export PATH="${PATH}:$workdir/python_embeded/Scripts"

# This command will let the .pyc files to be stored in one place.
export PYTHONPYCACHEPREFIX="$workdir/pycache"

# This command will copy u2net.onnx to user's home path, to skip download at first start.
if [ ! -f "${HOME}/.u2net/u2net.onnx" ]; then
  if [ -f "./extras/u2net.onnx" ]; then
    mkdir -p "${HOME}/.u2net"
    cp "./extras/u2net.onnx" "${HOME}/.u2net/u2net.onnx"
  fi
fi

# Download the TRELLIS model (will skip if exist)
if [ ! -f "$workdir/python_embeded/Scripts/.hf-hub-reinstalled" ] ; then
    $workdir/python_embeded/python.exe -s -m pip install --force-reinstall huggingface-hub
    touch "$workdir/python_embeded/Scripts/.hf-hub-reinstalled"
fi ;

$workdir/python_embeded/Scripts/huggingface-cli.exe download JeffreyXiang/TRELLIS-image-large

# Run the TRELLIS official Gradio demo
./python_embeded/python.exe -s TRELLIS/app.py
