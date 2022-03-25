#!/bin/bash
set -e

version=""
version_snake_cased=""

if [ ! -z $1 ]; then
    version="."
    version+=$1

    version_snake_cased=${version//./_}
fi

project_root=$(pwd)

rm -Rf ./export

mkdir export
mkdir export/broken_seals${version_snake_cased}_android_release
mkdir export/broken_seals${version_snake_cased}_android_debug
mkdir export/broken_seals${version_snake_cased}_linux
mkdir export/broken_seals${version_snake_cased}_windows
mkdir export/broken_seals${version_snake_cased}_javascript
mkdir export/broken_seals${version_snake_cased}_pi4
mkdir export/broken_seals${version_snake_cased}_osx
mkdir export/export_templates_bs${version_snake_cased}

./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export-debug Android-Release ${project_root}/export/broken_seals${version_snake_cased}_android_release/broken_seals${version_snake_cased}.apk
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export-debug Android ${project_root}/export/broken_seals${version_snake_cased}_android_debug/broken_seals_debug${version_snake_cased}.apk
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export Linux/X11 ${project_root}/export/broken_seals${version_snake_cased}_linux/broken_seals${version_snake_cased}_x11
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export "Windows Desktop" ${project_root}/export/broken_seals${version_snake_cased}_windows/broken_seals${version_snake_cased}.exe
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export HTML5 ${project_root}/export/broken_seals${version_snake_cased}_javascript/broken_seals.html
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export PI4/X11 ${project_root}/export/broken_seals${version_snake_cased}_pi4/broken_seals${version_snake_cased}_pi4
./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 --path ./game/ --export "Mac OSX" ${project_root}/export/broken_seals${version_snake_cased}_osx/broken_seals${version_snake_cased}.app

cp ./pandemonium_engine/bin/pandemonium.windows.opt.tools.64.exe ${project_root}/export/pandemonium.bs${version}.windows.opt.tools.64.exe
cp ./pandemonium_engine/bin/pandemonium.x11.opt.tools.64 ${project_root}/export/pandemonium.bs${version}.x11.opt.tools.64
cp ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.tools.32 ${project_root}/export/pandemonium.bs${version}.x11.pi4.opt.tools.32
cp ./pandemonium_engine/bin/pandemonium.javascript.opt.tools.threads.zip ${project_root}/export/pandemonium.bs${version}.javascript.opt.tools.zip
cp ./pandemonium_engine/bin/android_editor.apk ${project_root}/export/pandemonium.bs${version}.android_editor.apk
cp ./pandemonium_engine/bin/Pandemonium.app.zip ${project_root}/export/pandemonium.bs${version}.osx.opt.tools.zip

cp ./pandemonium_engine/bin/android_debug.apk ${project_root}/export/export_templates_bs${version_snake_cased}/android_debug.apk
cp ./pandemonium_engine/bin/android_release.apk ${project_root}/export/export_templates_bs${version_snake_cased}/android_release.apk
cp ./pandemonium_engine/bin/pandemonium.javascript.opt.debug.zip ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.javascript.opt.debug.zip
cp ./pandemonium_engine/bin/pandemonium.javascript.opt.zip ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.javascript.opt.zip
cp ./pandemonium_engine/bin/pandemonium.windows.opt.64.exe ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.windows.opt.64.exe
cp ./pandemonium_engine/bin/pandemonium.windows.opt.debug.64.exe ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.windows.opt.debug.64.exe
cp ./pandemonium_engine/bin/pandemonium.x11.opt.64 ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.x11.opt.64
cp ./pandemonium_engine/bin/pandemonium.x11.opt.debug.64 ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.x11.opt.debug.64
cp ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.32 ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.x11.pi4.opt.32
cp ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.debug.32 ${project_root}/export/export_templates_bs${version_snake_cased}/pandemonium.x11.pi4.opt.debug.32
cp ./pandemonium_engine/bin/osx.zip ${project_root}/export/export_templates_bs${version_snake_cased}/osx.zip
