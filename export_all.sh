#!/bin/bash
set -e

project_root=$(pwd)

rm -Rf ./export

mkdir export
mkdir export/broken_seals_android_release
mkdir export/broken_seals_android_debug
mkdir export/broken_seals_linux
mkdir export/broken_seals_windows
mkdir export/broken_seals_javascript

./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export-debug Android-Release ${project_root}/export/broken_seals_android_release/broken_seals.apk
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export-debug Android ${project_root}/export/broken_seals_android_debug/broken_seals_debug.apk
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export Linux/X11 ${project_root}/export/broken_seals_linux/broken_seals_x11
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export "Windows Desktop" ${project_root}/export/broken_seals_windows/broken_seals.exe
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export HTML5 ${project_root}/export/broken_seals_javascript/broken_seals.html

cp ./engine/bin/godot.windows.opt.tools.64.exe ${project_root}/export/godot.bs.windows.opt.tools.64.exe
cp ./engine/bin/godot.x11.opt.tools.64 ${project_root}/export/godot.bs.x11.opt.tools.64