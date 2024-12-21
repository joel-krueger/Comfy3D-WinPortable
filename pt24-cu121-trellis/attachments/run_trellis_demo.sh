#!/bin/bash
set -eu

# This script is equivalent to `run_trellis_demo.bat`.
# I made it archived here as a backup.

# You need to install <Git for Windows> with <Git Bash> (installed by default).
# Download: https://git-scm.com/download/win

################################################################################
# Edit this first! According to your GPU model.
export TORCH_CUDA_ARCH_LIST="6.1+PTX"

export CUDA_HOME="/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.4"

################################################################################
# Optional Optimizations

# If run only once, set to "native".
# "auto" will be faster but will do benchmarking at the beginning.
export SPCONV_ALGO="native"

# Default to "xformers" for compatibility
# "flash-attn" for higher performance.
# Flash Attention can ONLY be used on Ampere and later GPUs (RTX 30 series / A100 and beyond).
export ATTN_BACKEND="xformers"

################################################################################

# To set proxy, uncomment and edit the lines below
# (remove '#' in the beginning of line).
#export HTTP_PROXY=http://localhost:1081
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#echo "[INFO] Proxy set to $HTTP_PROXY"

# To set mirror site for PIP & HuggingFace Hub, uncomment and edit the two lines below.
#export PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
#export HF_ENDPOINT="https://hf-mirror.com"

################################################################################

workdir="$(pwd)"

# This command redirects HuggingFace-Hub to download model files in this folder.
export HF_HUB_CACHE="$workdir/HuggingFaceHub"

# This command redirects Pytorch Hub to download model files in this folder.
export TORCH_HOME="$workdir/TorchHome"

# This command will set PATH environment variable.
export PATH="${PATH}:$workdir/python_embeded/Scripts:${CUDA_HOME}/bin"

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
    $workdir/python_embeded/python.exe -s -m pip uninstall --yes huggingface-hub
    $workdir/python_embeded/python.exe -s -m pip install huggingface-hub
    touch "$workdir/python_embeded/Scripts/.hf-hub-reinstalled"
fi ;

echo "########################################"
echo "[INFO] Checking TRELLIS model..."
echo "########################################"

$workdir/python_embeded/Scripts/huggingface-cli.exe download JeffreyXiang/TRELLIS-image-large

# Run the TRELLIS official Gradio demo

echo "########################################"
echo "[INFO] Starting TRELLIS demo..."
echo "########################################"

cd TRELLIS
../python_embeded/python.exe -s app.py
