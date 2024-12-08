@REM These files are required to run "All stage Unique3D workflow",
@REM but are too big to be bundled in archive.
@REM If you already have them, just put them into the regarding folders.

set PATH=%PATH%;%~dp0\python_embeded\Scripts

aria2c.exe ^
 "https://huggingface.co/stablediffusiontutorials/stable-diffusion-v1.5/resolve/main/v1-5-pruned-emaonly.safetensors?download=true" ^
 -d ".\ComfyUI\models\checkpoints"

aria2c.exe ^
 "https://huggingface.co/spaces/Wuvin/Unique3D/resolve/main/ckpt/controlnet-tile/diffusion_pytorch_model.safetensors?download=true" ^
 -d ".\ComfyUI\models\controlnet" ^
 -o "controlnet-tile-fine-tuned.safetensors"

aria2c.exe ^
 "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors?download=true" ^
 -d ".\ComfyUI\models\ipadapter"

aria2c.exe ^
 "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors?download=true" ^
 -d ".\ComfyUI\models\clip_vision" ^
 -o "OpenCLIP-ViT-H-14.safetensors"
