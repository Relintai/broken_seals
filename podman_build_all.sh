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

$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bew -j4 . 2>&1 | tee logs/bew.log
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bewd -j4 . 2>&1 | tee logs/bewd.log
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bw -j4 . 2>&1 | tee logs/bw.log
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bwr -j4 . 2>&1 | tee logs/bwr.log

$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bel -j4 . 2>&1 | tee logs/bel.log
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons beld -j4 . 2>&1 | tee logs/beld.log
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bl -j4 . 2>&1 | tee logs/bl.log
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons blr -j4 . 2>&1 | tee logs/blr.log


$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} scons bj -j4 . 2>&1 | tee logs/bj.log
$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} scons bjr -j4 . 2>&1 | tee logs/bjr.log

$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons ba -j4 . 2>&1 | tee logs/ba.log
$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons bar -j4 . 2>&1 | tee logs/bar.log

# $podman run -v ${project_root}:/root/project -i -w /root/project -t godot-windows:${img_version} scons bew -j4

