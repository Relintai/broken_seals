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

rm -Rf ./release

mkdir release

cd export

rm -Rf broken_seals${version_snake_cased}_full_source
rm -Rf broken_seals${version_snake_cased}_game_source

mkdir broken_seals${version_snake_cased}_full_source
mkdir broken_seals${version_snake_cased}_game_source

# Warn if a file is over a megabyte. Used to catch big temporary files that would slip through outherwise
python ../tools/copy_repos.py ../ ./broken_seals${version_snake_cased}_full_source 1048576
python ../tools/copy_repos.py ../game/ ./broken_seals${version_snake_cased}_game_source

zip -q ../release/broken_seals${version_snake_cased}_android_debug.zip  ./broken_seals${version_snake_cased}_android_debug/*
zip -q ../release/broken_seals${version_snake_cased}_android_release.zip  ./broken_seals${version_snake_cased}_android_release/*
zip -q ../release/broken_seals${version_snake_cased}_javascript.zip  ./broken_seals${version_snake_cased}_javascript/*
zip -q ../release/broken_seals${version_snake_cased}_linux.zip  ./broken_seals${version_snake_cased}_linux/*
zip -q ../release/broken_seals${version_snake_cased}_windows.zip  ./broken_seals${version_snake_cased}_windows/*
zip -q ../release/broken_seals${version_snake_cased}_pi4.zip  ./broken_seals${version_snake_cased}_pi4/*
zip -q ../release/broken_seals${version_snake_cased}_osx.zip  ./broken_seals${version_snake_cased}_osx/*

# Editor
zip -q ../release/editor_windows_bs${version_snake_cased}.zip  ./godot.bs${version}.windows.opt.tools.64.exe
zip -q ../release/editor_linux_bs${version_snake_cased}.zip  ./godot.bs${version}.x11.opt.tools.64
zip -q ../release/editor_pi4_bs${version_snake_cased}.zip  ./godot.bs${version}.x11.pi4.opt.tools.32
cp  ./godot.bs${version}.javascript.opt.tools.zip ../release/editor_javascript_bs${version_snake_cased}.zip
zip -q ../release/editor_osx_bs${version_snake_cased}.zip  ./godot.bs${version}.osx.opt.tools.zip

zip -q ../release/export_templates_bs${version_snake_cased}.zip  ./export_templates_bs${version_snake_cased}/*

zip -q -r ../release/broken_seals${version_snake_cased}_full_source.zip  ./broken_seals${version_snake_cased}_full_source/*
zip -q -r ../release/broken_seals${version_snake_cased}_game_source.zip  ./broken_seals${version_snake_cased}_game_source/*

cd ..

