#!/bin/bash

set -e

podman=podman
if ! which $podman; then
  podman=docker
fi

registry=$1

if [ -z "${registry}" ]; then
  registry=registry.prehensile-tales.com
fi

$podman push godot-export:latest ${registry}/godot/export
$podman push godot-mono-glue:latest ${registry}/godot/mono-glue
$podman push godot-windows:latest ${registry}/godot/windows
$podman push godot-ubuntu-32:latest ${registry}/godot/ubuntu-32
$podman push godot-ubuntu-64:latest ${registry}/godot/ubuntu-64
$podman push godot-javascript:latest ${registry}/godot/javascript
$podman push godot-xcode-packer:latest ${registry}/godot/xcode-packer

$podman push godot-android:latest ${registry}/godot-private/android
$podman push godot-ios:latest ${registry}/godot-private/ios
$podman push godot-osx:latest ${registry}/godot-private/macosx
$podman push godot-msvc:latest ${registry}/godot-private/uwp
