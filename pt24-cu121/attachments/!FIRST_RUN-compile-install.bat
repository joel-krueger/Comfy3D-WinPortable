@REM Edit this to your GPU arch.
@REM You don't need to add the "+PTX". Here it works as a fail-safe (providing forward compatibility).
set TORCH_CUDA_ARCH_LIST=6.1+PTX

@REM Compile-install PyTorch3D
@REM PyTorch3D on Windows works best through compile-install. Binary-install will fail on some workflows.
@REM e.g. "CUDA error: no kernel image is available for execution on the device"

set CMAKE_ARGS=-DBUILD_opencv_world=ON -DWITH_CUDA=ON -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DWITH_NVCUVID=ON
set PATH=%PATH%;%~dp0\python_embeded\Scripts

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 "git+https://github.com/facebookresearch/pytorch3d.git@V0.7.8"

@REM Compile-install pointnet2_ops for Triplane Gaussian

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 .\extras\pointnet2_ops

@REM Compile-install diff-gaussian-rasterization for Triplane Gaussian

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 "git+https://github.com/ashawkey/diff-gaussian-rasterization.git"

@REM Compile-install simple-knn

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 .\extras\simple-knn
