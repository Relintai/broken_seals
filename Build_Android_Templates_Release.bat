
cd ./engine

call scons -j6 platform=android target=release android_arch=armv7 entities_2d=no
call scons -j6 platform=android target=release android_arch=arm64v8 entities_2d=no
call scons -j6 platform=android target=release android_arch=x86 entities_2d=no

cd ./platform/android/java

call .\gradlew.bat build

cd ..
cd ..
cd ..
cd ..