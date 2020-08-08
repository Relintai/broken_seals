#!/bin/bash
set -e

podman=`which podman || true`

if [ -z $podman ]; then
  echo "podman needs to be in PATH for this script to work."
  exit 1
fi

project_root=$(pwd)/
img_version=bs

#mkdir -p logs

$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bew -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bewd -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bw -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-windows:${img_version} scons bwr -j4

$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bel -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons beld -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons bl -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-linux:${img_version} scons blr -j4


$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} scons bj -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-javascript:${img_version} scons bjr -j4

$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons ba -j4
$podman run -v ${project_root}:/root/project -w /root/project godot-android:${img_version} scons bar -j4

# $podman run -v ${project_root}:/root/project -i -w /root/project -t godot-windows:${img_version} scons bew -j4

