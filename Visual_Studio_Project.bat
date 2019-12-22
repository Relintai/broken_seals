
rem call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd6

cd ./engine

rem scons -j6 platform=windows

"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64 && scons -j6 p=windows target=release_debug vsproj=yes voxel_mem_tools=no entities_2d=no entity_mem_tools=no
