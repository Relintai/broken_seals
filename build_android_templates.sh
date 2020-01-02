#!/bin/bash

export ANDROID_NDK_ROOT=~/SDKs/Android/NDK/android-ndk-r20b
export ANDROID_NDK_HOME=~/SDKs/Android/NDK/android-ndk-r20b
export ANDROID_HOME=~/SDKs/Android/SDK

cd ./engine

scons -j6 platform=android target=release_debug android_arch=armv7 
scons -j6 platform=android target=release_debug android_arch=arm64v8 
scons -j6 platform=android target=release_debug android_arch=x86 

cd ./platform/android/java

./gradlew generateGodotTemplates

cd ..
cd ..
cd ..
cd ..
