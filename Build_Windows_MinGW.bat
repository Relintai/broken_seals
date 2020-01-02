
rem call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

cd ./engine

rem scons -j6 platform=windows

call scons -j6 platform=windows target=release_debug use_mingw=yes
 
cd ..

