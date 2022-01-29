#!/bin/bash
set -e

podman=`which podman || true`

if [ -z $podman ]; then
  echo "podman needs to be in PATH for this script to work."
  exit 1
fi

project_root=$(pwd)/
img_version=bs

mkdir -p logs

#sudo podman run -i -t -v $(pwd)/files:/root/files godot-osx:bs /bin/bash
#sudo podman run -i -t -v $(pwd)/:/root/project -w /root/project godot-osx:bs /bin/bash
#sudo podman run -v $(pwd)/:/root/project -w /root/project godot-osx:bs scons bex_strip arch=x86_64 -j4 osxcross_sdk=darwin20.4
#sudo podman run -i -t -v $(pwd)/:/root/project -w /root/project/tools/osx godot-osx:bs bash -c ./lipo.sh

rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bew_strip -j4 . 2>&1 | tee logs/bew.log
rm -f engine/modules/modules_enabled.gen.h
#$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bewd_strip -j4 . 2>&1 | tee logs/bewd.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bw_strip -j4 . 2>&1 | tee logs/bw.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bwr_strip -j4 . 2>&1 | tee logs/bwr.log
rm -f engine/modules/modules_enabled.gen.h


$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bel_strip -j4 . 2>&1 | tee logs/bel.log
rm -f engine/modules/modules_enabled.gen.h
#$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons beld_strip -j4 . 2>&1 | tee logs/beld.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bl_strip -j4 . 2>&1 | tee logs/bl.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons blr_strip -j4 . 2>&1 | tee logs/blr.log
rm -f engine/modules/modules_enabled.gen.h


$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} bash -c 'source /root/emsdk_2.0.25/emsdk_env.sh;scons bj_strip -j4' . 2>&1 | tee logs/bj.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} bash -c 'source /root/emsdk_2.0.25/emsdk_env.sh;scons bjr_strip -j4' . 2>&1 | tee logs/bjr.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} bash -c 'source /root/emsdk_2.0.25/emsdk_env.sh;scons bej_strip_threads -j4' . 2>&1 | tee logs/bej.log
rm -f engine/modules/modules_enabled.gen.h

$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons ba_strip -j4 . 2>&1 | tee logs/ba.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons bar_strip -j4 . 2>&1 | tee logs/bar.log
rm -f engine/modules/modules_enabled.gen.h

#osx
$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bex_strip arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bex_x86_64.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bex_strip arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bex_arm64.log
rm -f engine/modules/modules_enabled.gen.h

$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bx_strip arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bx_x86_64.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bx_strip arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bx_arm64.log
rm -f engine/modules/modules_enabled.gen.h

$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bxr_strip arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bxr_x86_64.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-osx:${img_version} scons bxr_strip arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/bxr_arm64.log
rm -f engine/modules/modules_enabled.gen.h

#lipo
$podman run -v ${project_root}:/root/project -w /root/project/tools/osx godot-osx:${img_version} bash -c ./lipo.sh

#ios
#$podman run -v ${project_root}:/root/project -w /root/project godot-ios:${img_version} scons bir_strip -j4 . 2>&1 | tee logs/bir.log
#rm -f engine/modules/modules_enabled.gen.h

# $podman run -v ${project_root}:/root/project -i -w /root/project -t godot-windows:${img_version} scons bew -j4
rm -f engine/modules/modules_enabled.gen.h


# Check files

cd ./engine/bin/

files=(
  # Windows
  "godot.windows.opt.64.exe"
  "godot.windows.opt.debug.64.exe"
  "godot.windows.opt.tools.64.exe"
  # Linux
  "godot.x11.opt.64"
  "godot.x11.opt.debug.64"
  "godot.x11.opt.tools.64"
  # JS
  "godot.javascript.opt.tools.threads.zip"
  "godot.javascript.opt.zip"
  # Android
  "android_debug.apk"
  "android_release.apk"
  # OSX
  "godot.osx.opt.arm64"
  "godot.osx.opt.debug.arm64"
  "godot.osx.opt.debug.universal"
  "godot.osx.opt.debug.x86_64"
  "godot.osx.opt.tools.arm64"
  "godot.osx.opt.tools.universal"
  "godot.osx.opt.tools.x86_64"
  "godot.osx.opt.universal"
  "godot.osx.opt.x86_64"
)

error=0

for f in ${files[*]} 
do
if [ ! -e $f ]; then
  error=1
  echo "$f is not present!"
fi
done

if [ $error -eq 0 ]; then
  echo "All files are present!"
fi

cd ../..