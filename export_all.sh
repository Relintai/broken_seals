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
mkdir export/broken_seals_pi4
mkdir export/export_templates

./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export-debug Android-Release ${project_root}/export/broken_seals_android_release/broken_seals.apk
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export-debug Android ${project_root}/export/broken_seals_android_debug/broken_seals_debug.apk
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export Linux/X11 ${project_root}/export/broken_seals_linux/broken_seals_x11
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export "Windows Desktop" ${project_root}/export/broken_seals_windows/broken_seals.exe
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export HTML5 ${project_root}/export/broken_seals_javascript/broken_seals.html
./engine/bin/godot.x11.opt.tools.64 --path ./game/ --export PI4/X11 ${project_root}/export/broken_seals_pi4/broken_seals_pi4

cp ./engine/bin/godot.windows.opt.tools.64.exe ${project_root}/export/godot.bs.windows.opt.tools.64.exe
cp ./engine/bin/godot.x11.opt.tools.64 ${project_root}/export/godot.bs.x11.opt.tools.64
cp ./engine/bin/godot.x11.pi4.opt.tools.32 ${project_root}/export/godot.bs.x11.pi4.opt.tools.32

cp ./engine/bin/android_debug.apk ${project_root}/export/export_templates/android_debug.apk
cp ./engine/bin/android_release.apk ${project_root}/export/export_templates/android_release.apk
cp ./engine/bin/godot.javascript.opt.debug.zip ${project_root}/export/export_templates/godot.javascript.opt.debug.zip
cp ./engine/bin/godot.javascript.opt.zip ${project_root}/export/export_templates/godot.javascript.opt.zip
cp ./engine/bin/godot.windows.opt.64.exe ${project_root}/export/export_templates/godot.windows.opt.64.exe
cp ./engine/bin/godot.windows.opt.debug.64.exe ${project_root}/export/export_templates/godot.windows.opt.debug.64.exe
cp ./engine/bin/godot.x11.opt.64 ${project_root}/export/export_templates/godot.x11.opt.64
cp ./engine/bin/godot.x11.opt.debug.64 ${project_root}/export/export_templates/godot.x11.opt.debug.64
cp ./engine/bin/godot.x11.pi4.opt.32 ${project_root}/export/export_templates/godot.x11.pi4.opt.32
cp ./engine/bin/godot.x11.pi4.opt.debug.32 ${project_root}/export/export_templates/godot.x11.pi4.opt.debug.32


