#!/bin/bash
set -eux

# Chores
gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'
workdir=$(pwd)
export PYTHONPYCACHEPREFIX="$workdir"/pycache
export PATH="$PATH:$workdir/Comfy3D_WinPortable/python_embeded/Scripts"

ls -lahF
mkdir -p "$workdir"/Comfy3D_WinPortable

# Redirect HuggingFace-Hub model folder
export HF_HUB_CACHE="$workdir/Comfy3D_WinPortable/HuggingFaceHub"
mkdir -p "$HF_HUB_CACHE"

# ComfyUI main app
git clone https://github.com/comfyanonymous/ComfyUI.git \
    "$workdir"/Comfy3D_WinPortable/ComfyUI
cd "$workdir"/Comfy3D_WinPortable/ComfyUI
git reset --hard "v0.3.7"

# CUSTOM NODES
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes

# 3D-Pack
mv "$workdir"/ComfyUI-3D-Pack ./ComfyUI-3D-Pack
# Make sure Manager won't update its deps anyway
rm ./ComfyUI-3D-Pack/requirements.txt
rm ./ComfyUI-3D-Pack/install.py
rm -rf ./ComfyUI-3D-Pack/_Pre_Builds

# Install ComfyUI-Manager but disable it by default
git clone https://ghp.ci/https://github.com/ltdrdata/ComfyUI-Manager.git
mv ComfyUI-Manager ComfyUI-Manager.disabled

$gcs https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git
mv AIGODLIKE-ComfyUI-Translation AIGODLIKE-ComfyUI-Translation.disabled

$gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
$gcs https://github.com/kijai/ComfyUI-KJNodes.git
$gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
$gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
$gcs https://github.com/WASasquatch/was-node-suite-comfyui.git
$gcs https://github.com/edenartlab/eden_comfy_pipelines.git

git clone https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
cd ComfyUI-Inspire-Pack
git reset --hard "1.9"

cd "$workdir"
mv  python_embeded  Comfy3D_WinPortable/python_embeded

# Download Impact-Pack & Subpack & models
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
cd ComfyUI-Impact-Pack
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git impact_subpack
# Use its installer to download models
"$workdir"/Comfy3D_WinPortable/python_embeded/python.exe -s -B install.py

# Run test, also let custom nodes download some models
cd "$workdir"/Comfy3D_WinPortable
./python_embeded/python.exe -s -B ComfyUI/main.py --quick-test-for-ci --cpu

# Download extra models
# u2net model needed by rembg (to avoid download at first start)
cd "$workdir"/Comfy3D_WinPortable
mkdir extras
curl -sSL https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx \
    -o ./extras/u2net.onnx

# RealESRGAN_x4plus needed by example workflows
curl -sSL https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth \
    -o "$workdir"/Comfy3D_WinPortable/ComfyUI/models/upscale_models/RealESRGAN_x4plus.pth

# Copy/Move example files of 3D-Pack
mkdir -p "$workdir"/Comfy3D_WinPortable/ComfyUI/user/default/workflows

cp -r "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/ComfyUI-3D-Pack/_Example_Workflows/. \
    "$workdir"/Comfy3D_WinPortable/ComfyUI/user/default/workflows/

rm -rf "$workdir"/Comfy3D_WinPortable/ComfyUI/user/default/workflows/_Example_Inputs_Files
rm -rf "$workdir"/Comfy3D_WinPortable/ComfyUI/user/default/workflows/_Example_Outputs

mv "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/ComfyUI-3D-Pack/_Example_Workflows/_Example_Inputs_Files/* \
    "$workdir"/Comfy3D_WinPortable/ComfyUI/input/

# Move source files needed by user compile-install
mv "$workdir"/Comfy3D_Pre_Builds/_Libs/*  "$workdir"/Comfy3D_WinPortable/extras/

# Copy & overwrite attachments
cp -rf "$workdir"/attachments/* \
    "$workdir"/Comfy3D_WinPortable/

# Clean up
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes
rm ./was-node-suite-comfyui/was_suite_config.json
rm ./ComfyUI-Impact-Pack/impact-pack.ini

cd "$workdir"
