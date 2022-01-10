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

python ../tools/copy_repos.py ../ ./broken_seals${version_snake_cased}_full_source
python ../tools/copy_repos.py ../game/ ./broken_seals${version_snake_cased}_game_source

zip  ../release/broken_seals${version_snake_cased}_android_debug.zip  ./broken_seals${version_snake_cased}_android_debug/*
zip  ../release/broken_seals${version_snake_cased}_android_release.zip  ./broken_seals${version_snake_cased}_android_release/*
zip  ../release/broken_seals${version_snake_cased}_javascript.zip  ./broken_seals${version_snake_cased}_javascript/*
zip  ../release/broken_seals${version_snake_cased}_linux.zip  ./broken_seals${version_snake_cased}_linux/*
zip  ../release/broken_seals${version_snake_cased}_windows.zip  ./broken_seals${version_snake_cased}_windows/*
zip  ../release/broken_seals${version_snake_cased}_pi4.zip  ./broken_seals${version_snake_cased}_pi4/*

zip  ../release/editor_windows${version_snake_cased}.zip  ./godot.bs${version}.windows.opt.tools.64.exe
zip  ../release/editor_linux${version_snake_cased}.zip  ./godot.bs${version}.x11.opt.tools.64
zip  ../release/editor_pi4${version_snake_cased}.zip  ./godot.bs${version}.x11.pi4.opt.tools.32

zip  ../release/export_templates${version_snake_cased}.zip  ./export_templates${version_snake_cased}/*

zip -r ../release/broken_seals${version_snake_cased}_full_source.zip  ./broken_seals${version_snake_cased}_full_source/*
zip -r ../release/broken_seals${version_snake_cased}_game_source.zip  ./broken_seals${version_snake_cased}_game_source/*

cd ..

