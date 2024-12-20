@REM Edit this first! According to your GPU model.
set TORCH_CUDA_ARCH_LIST=6.1+PTX

@REM Set the correct path for CUDA Toolkit if you install it elsewhere.
set CUDA_HOME=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1

@REM Optional Optimization 1
@REM "native" for quick start.
@REM "auto" for performance, but need benchmarking at the beginning.
set SPCONV_ALGO=native

@REM Optional Optimization 2
@REM "xformers" for compatibility.
@REM "flash-attn" for performance (need RTX 30/A100 or later GPU).
set ATTN_BACKEND=xformers

@REM To set proxy, edit and uncomment the two lines below (remove 'rem ' in the beginning of line).
rem set HTTP_PROXY=http://localhost:1081
rem set HTTPS_PROXY=http://localhost:1081

@REM To set mirror site for PIP & HuggingFace Hub, uncomment and edit the two lines below.
rem set PIP_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
rem set HF_ENDPOINT=https://hf-mirror.com

@REM To set HuggingFace Access Token, uncomment and edit the line below.
@REM https://huggingface.co/settings/tokens
rem set HF_TOKEN=

@REM To enable HuggingFace Hub's experimental high-speed file transfer, uncomment the line below.
@REM https://huggingface.co/docs/huggingface_hub/hf_transfer
rem set HF_HUB_ENABLE_HF_TRANSFER=1

@REM ===========================================================================

@REM This command redirects HuggingFace-Hub to download model files in this folder.
set HF_HUB_CACHE=%~dp0\HuggingFaceHub

@REM This command redirects Pytorch Hub to download model files in this folder.
set TORCH_HOME=%~dp0\TorchHome

@REM This command will set PATH environment variable.
set PATH=%PATH%;%~dp0\python_embeded\Scripts
set PATH=%PATH%;%CUDA_HOME%\bin

@REM This command will let the .pyc files to be stored in one place.
set PYTHONPYCACHEPREFIX=%~dp0\pycache

@REM ===========================================================================

@REM Start TRELLIS demo
cd TRELLIS
..\python_embeded\python.exe -s app.py

pause
