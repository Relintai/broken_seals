
cd ./engine

call scons -j6 platform=android target=release android_arch=armv7 
call scons -j6 platform=android target=release android_arch=arm64v8 
call scons -j6 platform=android target=release android_arch=x86 

cd ./platform/android/java

call .\gradlew.bat build

cd ..
cd ..
cd ..
cd ..