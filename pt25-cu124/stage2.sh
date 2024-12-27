#!/bin/bash
set -eux

# Chores
gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'
workdir=$(pwd)
export PYTHONPYCACHEPREFIX="${workdir}/pycache2"
export PATH="$PATH:$workdir/Comfy3D_WinPortable/python_embeded/Scripts"

ls -lahF

mkdir -p "$workdir"/Comfy3D_WinPortable/extras

# This move is intentional.
# If relocating python_embeded breaks, later test will fail fast.
mv  "$workdir"/python_embeded  "$workdir"/Comfy3D_WinPortable/python_embeded

# Redirect HuggingFace-Hub model folder
export HF_HUB_CACHE="$workdir/Comfy3D_WinPortable/HuggingFaceHub"
mkdir -p "${HF_HUB_CACHE}"
# Redirect Pytorch Hub model folder
export TORCH_HOME="$workdir/Comfy3D_WinPortable/TorchHome"
mkdir -p "${TORCH_HOME}"

# ComfyUI main app (latest)
git clone https://github.com/comfyanonymous/ComfyUI.git \
    "$workdir"/Comfy3D_WinPortable/ComfyUI

# TRELLIS app
$gcs https://github.com/microsoft/TRELLIS.git \
    "$workdir"/Comfy3D_WinPortable/TRELLIS

# CUSTOM NODES
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes

# 3D-Pack
mv "$workdir"/ComfyUI-3D-Pack ./ComfyUI-3D-Pack
# Make sure Manager won't update its deps anyway
rm ./ComfyUI-3D-Pack/requirements.txt
rm ./ComfyUI-3D-Pack/install.py
rm -rf ./ComfyUI-3D-Pack/_Pre_Builds

# ComfyUI-Manager
# This time not disable it
$gcs https://github.com/ltdrdata/ComfyUI-Manager.git

# SF3D
$gcs https://github.com/Stability-AI/stable-fast-3d.git

$gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
$gcs https://github.com/edenartlab/eden_comfy_pipelines.git
$gcs https://github.com/kijai/ComfyUI-KJNodes.git
$gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
$gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
$gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
$gcs https://github.com/WASasquatch/was-node-suite-comfyui.git

# Download models for Impact-Pack & Impact-Subpack
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/ComfyUI-Impact-Pack
"$workdir"/Comfy3D_WinPortable/python_embeded/python.exe -s -B install.py
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/ComfyUI-Impact-Subpack
"$workdir"/Comfy3D_WinPortable/python_embeded/python.exe -s -B install.py

# Run test, also let custom nodes download some models
cd "$workdir"/Comfy3D_WinPortable
./python_embeded/python.exe -s -B ComfyUI/main.py --quick-test-for-ci --cpu

################################################################################
# Download extra models
# u2net model needed by rembg (to avoid download at first start)
curl -sSL https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx \
    -o "$workdir"/Comfy3D_WinPortable/extras/u2net.onnx

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

# Example input files of SF3D
cp -r "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/stable-fast-3d/demo_files/examples/. \
    "$workdir"/Comfy3D_WinPortable/ComfyUI/input/

################################################################################
# Source files needed by user compile-install
cd "$workdir"/Comfy3D_WinPortable/extras/

mv "$workdir"/Comfy3D_Pre_Builds/_Libs/pointnet2_ops \
    "$workdir"/Comfy3D_WinPortable/extras/pointnet2_ops

mv "$workdir"/Comfy3D_Pre_Builds/_Libs/simple-knn \
    "$workdir"/Comfy3D_WinPortable/extras/simple-knn

cp -r "$workdir"/Comfy3D_WinPortable/TRELLIS/extensions/vox2seq \
    "$workdir"/Comfy3D_WinPortable/extras/vox2seq

# PyTorch3D
curl -sSL https://github.com/facebookresearch/pytorch3d/archive/refs/heads/main.zip \
    -o temp.zip
unzip -q temp.zip
mv pytorch3d-main pytorch3d
rm temp.zip

# Differential Octree Rasterization
$gcs https://github.com/JeffreyXiang/diffoctreerast.git

# Yet another diff-gaussian-rasterization (this version is used by TRELLIS)
curl -sSL https://github.com/autonomousvision/mip-splatting/archive/refs/heads/main.zip \
    -o temp.zip
unzip -q temp.zip
mv mip-splatting-main/submodules/diff-gaussian-rasterization ./diff-gaussian-rasterization
rm -rf mip-splatting-main
rm temp.zip

# Copy & overwrite attachments
cp -rf "$workdir"/attachments/* \
    "$workdir"/Comfy3D_WinPortable/

# Clean up
rm -v "$workdir"/Comfy3D_WinPortable/*.log
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes
rm ./was-node-suite-comfyui/was_suite_config.json

cd "$workdir"
