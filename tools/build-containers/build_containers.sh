#!/bin/bash
set -e

podman=`which podman || true`

if [ -z $podman ]; then
  echo "podman needs to be in PATH for this script to work."
  exit 1
fi

files_root=$(pwd)/files
img_version=bs

mkdir -p logs

export podman_build="$podman build --build-arg img_version=${img_version}"

$podman build -v ${files_root}:/root/files -t pandemonium-fedora:${img_version} -f Dockerfile.base . 2>&1 | tee logs/base.log
$podman_build -t pandemonium-linux:${img_version} -f Dockerfile.linux . 2>&1 | tee logs/linux.log
$podman_build -t pandemonium-windows:${img_version} -f Dockerfile.windows --ulimit nofile=65536 . 2>&1 | tee logs/windows.log
$podman_build -t pandemonium-javascript:${img_version} -f Dockerfile.javascript . 2>&1 | tee logs/javascript.log
$podman_build -t pandemonium-android:${img_version} -f Dockerfile.android . 2>&1 | tee logs/android.log

XCODE_SDK=12.5.1
OSX_SDK=11.3
IOS_SDK=14.5
if [ ! -e files/MacOSX${OSX_SDK}.sdk.tar.xz ] || [ ! -e files/iPhoneOS${IOS_SDK}.sdk.tar.xz ] || [ ! -e files/iPhoneSimulator${IOS_SDK}.sdk.tar.xz ]; then
  if [ ! -e files/Xcode_${XCODE_SDK}.xip ]; then
    echo "files/Xcode_${XCODE_SDK}.xip is required. It can be downloaded from https://developer.apple.com/download/more/ with a valid apple ID."
    exit 1
  fi

  echo "Building OSX and iOS SDK packages. This will take a while"
  $podman_build -t pandemonium-xcode-packer:${img_version} -f Dockerfile.xcode -v ${files_root}:/root/files . 2>&1 | tee logs/xcode.log
  $podman run -it --rm -v ${files_root}:/root/files pandemonium-xcode-packer:${img_version} 2>&1 | tee logs/xcode_packer.log
fi

$podman_build -t pandemonium-osx:${img_version} -v ${files_root}:/root/files -f Dockerfile.osx . 2>&1 | tee logs/osx.log
$podman_build -t pandemonium-ios:${img_version} -v ${files_root}:/root/files -f Dockerfile.ios . 2>&1 | tee logs/ios.log

if [ "${build_msvc}" != "0" ]; then
  if [ ! -e files/msvc2017.tar ]; then
    echo
    echo "files/msvc2017.tar is missing. This file can be created on a Windows 7 or 10 machine by downloading the 'Visual Studio Tools' installer."
    echo "here: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2017"
    echo "The required components can be installed by running"
    echo "vs_buildtools.exe --add Microsoft.VisualStudio.Workload.UniversalBuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop --add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP.Native --passive"
    echo "after that create a zipfile of C:/Program Files (x86)/Microsoft Visual Studio"
    echo "tar -cf msvc2017.tar -C \"c:/Program Files (x86)/ Microsoft Visual Studio\""
    echo
    exit 1
  fi

  $podman_build -t pandemonium-msvc:${img_version} -f Dockerfile.msvc -v ${files_root}:/root/files . 2>&1 | tee logs/msvc.log
fi
