@REM 运行 "All stage Unique3D workflow" 所需模型
@REM 如果下载失败，尝试手动下载，放到对应目录即可

set PATH=%PATH%;%~dp0\python_embeded\Scripts

aria2c.exe ^
 "https://hf-mirror.com/stablediffusiontutorials/stable-diffusion-v1.5/resolve/main/v1-5-pruned-emaonly.safetensors?download=true" ^
 -d ".\ComfyUI\models\checkpoints"

aria2c.exe ^
 "https://hf-mirror.com/spaces/Wuvin/Unique3D/resolve/main/ckpt/controlnet-tile/diffusion_pytorch_model.safetensors?download=true" ^
 -d ".\ComfyUI\models\controlnet" ^
 -o "controlnet-tile-fine-tuned.safetensors"

aria2c.exe ^
 "https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors?download=true" ^
 -d ".\ComfyUI\models\ipadapter"

aria2c.exe ^
 "https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors?download=true" ^
 -d ".\ComfyUI\models\clip_vision" ^
 -o "OpenCLIP-ViT-H-14.safetensors"
