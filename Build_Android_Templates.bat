rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

cd ./engine

call scons -j6 platform=android target=release_debug android_arch=armv7 entities_2d=no
call scons -j6 platform=android target=release_debug android_arch=arm64v8 entities_2d=no
call scons -j6 platform=android target=release_debug android_arch=x86 entities_2d=no

cd ./platform/android/java

rem call .\gradlew.bat build
call .\gradlew.bat generateGodotTemplates


cd ..
cd ..
cd ..
cd ..