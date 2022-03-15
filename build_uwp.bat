
cd ./pandemonium_engine

if not defined DevEnvDir (
    rem call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
)

call scons -j6 platform=uwp target=release 
rem call scons -j6 platform=uwp target=release_debug 
rem call scons -j6 platform=uwp target=release 
 
cd ..

