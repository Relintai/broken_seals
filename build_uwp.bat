rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

cd ./engine

if not defined DevEnvDir (
    rem call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
)

call scons -j6 platform=uwp target=release entities_2d=no
rem call scons -j6 platform=uwp target=release_debug entities_2d=no
rem call scons -j6 platform=uwp target=release entities_2d=no
 
cd ..

