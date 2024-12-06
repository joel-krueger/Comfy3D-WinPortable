#!/bin/bash
set -eux

git config --global core.autocrlf true

workdir=$(pwd)

pip_exe="${workdir}/python_embeded/python.exe -s -m pip"

export PYTHONPYCACHEPREFIX="${workdir}/pycache"

ls -lahF

# Download Python embeded
cd "$workdir"
curl -sSL https://github.com/adang1345/PythonWindows/raw/refs/heads/master/3.11.11/python-3.11.11-embed-amd64.zip \
    -o python_embeded.zip
unzip python_embeded.zip -d "$workdir"/python_embeded

# Download 3D-Pack
# Note: zip archive doesn't contain the ".git" folder, it's not upgradable.
cd "$workdir"
curl -sSL https://github.com/MrForExample/ComfyUI-3D-Pack/archive/3b4e715939376634c68aa4c1c7d4ea4a8665c098.zip \
    -o ComfyUI-3D-Pack-3b4e715939376634c68aa4c1c7d4ea4a8665c098.zip
unzip ComfyUI-3D-Pack-3b4e715939376634c68aa4c1c7d4ea4a8665c098.zip
mv ComfyUI-3D-Pack-3b4e715939376634c68aa4c1c7d4ea4a8665c098 ComfyUI-3D-Pack
rm ComfyUI-3D-Pack-3b4e715939376634c68aa4c1c7d4ea4a8665c098.zip

# Header files for ComfyUI-3D-Pack
# Do this firstly (in a clean python_embeded folder)
mv \
    "$workdir"/ComfyUI-3D-Pack/_Pre_Builds/_Python311_cpp/include \
    "$workdir"/python_embeded/include

mv \
    "$workdir"/ComfyUI-3D-Pack/_Pre_Builds/_Python311_cpp/libs \
    "$workdir"/python_embeded/libs

# Setup PIP
cd "$workdir"/python_embeded
sed -i 's/^#import site/import site/' ./python311._pth
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
./python.exe get-pip.py

# PIP installs
$pip_exe install --upgrade pip wheel setuptools

$pip_exe install -r "$workdir"/requirements2.txt
$pip_exe install -r "$workdir"/requirements3.txt
$pip_exe install -r "$workdir"/requirements4.txt
$pip_exe install -r "$workdir"/requirements5.txt
$pip_exe install -r "$workdir"/requirements6.txt

$pip_exe install "$workdir"/ComfyUI-3D-Pack/_Pre_Builds/_Wheels_win_py311_cu121/*.whl

$pip_exe install -r "$workdir"/requirements8.txt

# Add Ninja binary (replacing PIP Ninja)
## The 'python_embeded\Scripts\ninja.exe' is not working,
## because most .exe files in 'python_embeded\Scripts' are wrappers 
## that looking for 'C:\Absolute\Path\python.exe', which is not portable.
## So here we use the actual binary of Ninja.
## Whatsmore, if the end-user re-install/upgrade the PIP Ninja,
## the path problem will be fixed automatically.
curl -sSL https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip \
    -o ninja-win.zip
unzip -o ninja-win.zip -d "$workdir"/python_embeded/Scripts
rm ninja-win.zip

# Setup Python embeded, part 3/3
cd "$workdir"/python_embeded
sed -i '1i../ComfyUI' ./python311._pth

$pip_exe list

cd "$workdir"
