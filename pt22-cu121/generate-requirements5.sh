#!/bin/bash
set -eu

array=(
https://github.com/comfyanonymous/ComfyUI/raw/refs/tags/v0.0.1/requirements.txt
https://github.com/MrForExample/ComfyUI-3D-Pack/raw/3b4e715939376634c68aa4c1c7d4ea4a8665c098/requirements.txt
https://github.com/kijai/ComfyUI-KJNodes/raw/refs/heads/main/requirements.txt
https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Impact-Pack/raw/refs/heads/Main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Impact-Subpack/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Inspire-Pack/raw/refs/heads/main/requirements.txt
https://github.com/WASasquatch/was-node-suite-comfyui/raw/refs/heads/main/requirements.txt
)

for line in "${array[@]}";
    do curl -w "\n" -sSL "${line}" >> requirements5.txt
done

sed -i '/^#/d' requirements5.txt
sed -i 's/[[:space:]]*$//' requirements5.txt
sed -i 's/>=.*$//' requirements5.txt
sed -i 's/_/-/g' requirements5.txt

# Remove duplicate items, compare to requirements4.txt
grep -Fxv -f requirements4.txt requirements5.txt > temp.txt && mv temp.txt requirements5.txt

sort -uo requirements5.txt requirements5.txt

echo "<requirements5.txt> generated. Check before use."
