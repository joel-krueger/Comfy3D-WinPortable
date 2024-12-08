@REM 编辑为你的 GPU 对应架构
@REM 修改时无需保留 "+PTX" ，其用于向前兼容，防止用户忘了该步骤。
set TORCH_CUDA_ARCH_LIST=6.1+PTX

@REM 编译安装 PyTorch3D
@REM PyTorch3D 对 Windows 不甚友好，所有二进制安装都可能在某个节点报错，极难排查，故最好提前编译安装。

set CMAKE_ARGS=-DBUILD_opencv_world=ON -DWITH_CUDA=ON -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DWITH_NVCUVID=ON
set PATH=%PATH%;%~dp0\python_embeded\Scripts

set PIP_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 "git+https://ghp.ci/https://github.com/facebookresearch/pytorch3d.git@stable"

@REM 编译安装 pointnet2_ops ，该组件用于 Triplane Gaussian Transformers

.\python_embeded\python.exe -s -m pip install --force-reinstall ^
 .\extras\pointnet2_ops
