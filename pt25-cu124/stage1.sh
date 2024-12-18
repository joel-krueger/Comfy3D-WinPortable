#!/bin/bash
set -eux

# Chores
git config --global core.autocrlf true
gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'
workdir=$(pwd)
pip_exe="${workdir}/python_embeded/python.exe -s -m pip"
export PYTHONPYCACHEPREFIX="${workdir}/pycache1"
export PATH="$PATH:$workdir/Comfy3D_WinPortable/python_embeded/Scripts"
export PIP_NO_WARN_SCRIPT_LOCATION=0

ls -lahF

# Download Python embeded
cd "$workdir"
curl -sSL https://www.python.org/ftp/python/3.12.8/python-3.12.8-embed-amd64.zip \
    -o python_embeded.zip
unzip -q python_embeded.zip -d "$workdir"/python_embeded

# Download 3D-Pack
# Note: zip archive doesn't contain the ".git" folder, it's not upgradable.
cd "$workdir"
curl -sSL https://github.com/MrForExample/ComfyUI-3D-Pack/archive/0880fa8d2945b8abb990ad768e0cfe704e0d025e.zip \
    -o ComfyUI-3D-Pack-0880fa8d2945b8abb990ad768e0cfe704e0d025e.zip
unzip -q ComfyUI-3D-Pack-0880fa8d2945b8abb990ad768e0cfe704e0d025e.zip
mv ComfyUI-3D-Pack-0880fa8d2945b8abb990ad768e0cfe704e0d025e ComfyUI-3D-Pack
rm ComfyUI-3D-Pack-0880fa8d2945b8abb990ad768e0cfe704e0d025e.zip

cd "$workdir"
curl -sSL https://github.com/MrForExample/Comfy3D_Pre_Builds/archive/ac9f238f092b94ba319ce06f3ccd80b9d0f6c8c4.zip \
    -o Comfy3D_Pre_Builds-ac9f238f092b94ba319ce06f3ccd80b9d0f6c8c4.zip
unzip -q Comfy3D_Pre_Builds-ac9f238f092b94ba319ce06f3ccd80b9d0f6c8c4.zip
mv Comfy3D_Pre_Builds-ac9f238f092b94ba319ce06f3ccd80b9d0f6c8c4 Comfy3D_Pre_Builds
rm Comfy3D_Pre_Builds-ac9f238f092b94ba319ce06f3ccd80b9d0f6c8c4.zip

# Header files for ComfyUI-3D-Pack
# Do this firstly (in a clean python_embeded folder)
mv \
    "$workdir"/Comfy3D_Pre_Builds/_Python_Source_cpp/py312/include \
    "$workdir"/python_embeded/include

mv \
    "$workdir"/Comfy3D_Pre_Builds/_Python_Source_cpp/py312/libs \
    "$workdir"/python_embeded/libs

# Setup PIP
cd "$workdir"/python_embeded
sed -i 's/^#import site/import site/' ./python312._pth
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
./python.exe get-pip.py

# PIP installs
$pip_exe install --upgrade pip wheel setuptools

$pip_exe install -r "$workdir"/requirements2.txt
$pip_exe install -r "$workdir"/requirements3.txt
$pip_exe install -r "$workdir"/requirements4.txt
$pip_exe install -r "$workdir"/requirements5.txt
$pip_exe install -r "$workdir"/requirements6.txt

rm "$workdir"/Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_win_py312_torch2.5.1_cu124/torch_scatter-2.1.2-cp312-cp312-win_amd64.whl
$pip_exe install "$workdir"/Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_win_py312_torch2.5.1_cu124/*.whl

$pip_exe install -r "$workdir"/requirements8.txt
$pip_exe install -r "$workdir"/requirements9.txt
$pip_exe install -r "$workdir"/requirementsA.txt

# Add Ninja binary (replacing PIP Ninja)
## The 'python_embeded\Scripts\ninja.exe' is not working,
## because most .exe files in 'python_embeded\Scripts' are wrappers 
## that looking for 'C:\Absolute\Path\python.exe', which is not portable.
## So here we use the actual binary of Ninja.
## Whatsmore, if the end-user re-install/upgrade the PIP Ninja,
## the path problem will be fixed automatically.
curl -sSL https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip \
    -o ninja-win.zip
unzip -q -o ninja-win.zip -d "$workdir"/python_embeded/Scripts
rm ninja-win.zip

# Add aria2 binary
curl -sSL https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip \
    -o aria2.zip
unzip -q aria2.zip -d "$workdir"/aria2
mv "$workdir"/aria2/*/aria2c.exe  "$workdir"/python_embeded/Scripts/
rm aria2.zip

# Setup Python embeded, part 3/3
cd "$workdir"/python_embeded
sed -i '1i../ComfyUI' ./python312._pth

$pip_exe list

cd "$workdir"
