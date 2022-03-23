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

$podman push pandemonium-export:latest ${registry}/pandemonium/export
$podman push pandemonium-mono-glue:latest ${registry}/pandemonium/mono-glue
$podman push pandemonium-windows:latest ${registry}/pandemonium/windows
$podman push pandemonium-ubuntu-32:latest ${registry}/pandemonium/ubuntu-32
$podman push pandemonium-ubuntu-64:latest ${registry}/pandemonium/ubuntu-64
$podman push pandemonium-javascript:latest ${registry}/pandemonium/javascript
$podman push pandemonium-xcode-packer:latest ${registry}/pandemonium/xcode-packer

$podman push pandemonium-android:latest ${registry}/pandemonium-private/android
$podman push pandemonium-ios:latest ${registry}/pandemonium-private/ios
$podman push pandemonium-osx:latest ${registry}/pandemonium-private/macosx
$podman push pandemonium-msvc:latest ${registry}/pandemonium-private/uwp
