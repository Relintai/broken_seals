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

$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons ba_strip -j4 . 2>&1 | tee logs/ba.log
rm -f engine/modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons bar_strip -j4 . 2>&1 | tee logs/bar.log
rm -f engine/modules/modules_enabled.gen.h

# $podman run -v ${project_root}:/root/project -i -w /root/project -t godot-windows:${img_version} scons bew -j4
rm -f engine/modules/modules_enabled.gen.h

