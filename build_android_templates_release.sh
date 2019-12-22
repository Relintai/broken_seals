#!/bin/bash

export ANDROID_NDK_ROOT=~/SDKs/Android/NDK/android-ndk-r20b
export ANDROID_NDK_HOME=~/SDKs/Android/NDK/android-ndk-r20b
export ANDROID_HOME=~/SDKs/Android/SDK

cd ./engine

scons -j6 platform=android target=release android_arch=armv7 entities_2d=no
scons -j6 platform=android target=release android_arch=arm64v8 entities_2d=no
scons -j6 platform=android target=release android_arch=x86 entities_2d=no

cd ./platform/android/java

./gradlew generateGodotTemplates

cd ..
cd ..
cd ..
cd ..
