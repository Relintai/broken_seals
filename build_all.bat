rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

start "Android templates" /wait cmd /c call "Build_Android_Templates.bat" ^> 01.txt
start "Android templates release" /wait cmd /c call "Build_Android_Templates_Release.bat" ^> 02.txt
start "JS" /wait cmd /c call "Build_JavaScript.bat" ^> 03.txt
start "JS Release" /wait cmd /c call "build_javascript_release.bat" ^> 04.txt
start "Windows" /wait cmd /c call "Build_Windows.bat" ^> 05.txt
start "Window Templates" /wait cmd /c call "Build_Windows_Templates.bat" ^> 06.txt
start "Window Templates Release" /wait cmd /c call "Build_WIndows_Templates_rel.bat" ^> 07.txt

