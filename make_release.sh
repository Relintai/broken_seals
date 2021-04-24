#!/bin/bash
set -e

project_root=$(pwd)

rm -Rf ./release

mkdir release

cd export

rm -Rf broken_seals_full_source
rm -Rf broken_seals_game_source

mkdir broken_seals_full_source
mkdir broken_seals_game_source

python ../tools/copy_repos.py ../ ./broken_seals_full_source
python ../tools/copy_repos.py ../game/ ./broken_seals_game_source

zip  ../release/broken_seals_android_debug.zip  ./broken_seals_android_debug/*
zip  ../release/broken_seals_android_release.zip  ./broken_seals_android_release/*
zip  ../release/broken_seals_javascript.zip  ./broken_seals_javascript/*
zip  ../release/broken_seals_linux.zip  ./broken_seals_linux/*
zip  ../release/broken_seals_windows.zip  ./broken_seals_windows/*
zip  ../release/broken_seals_pi4.zip  ./broken_seals_pi4/*

zip  ../release/editor_windows.zip  ./godot.bs.windows.opt.tools.64.exe
zip  ../release/editor_linux.zip  ./godot.bs.x11.opt.tools.64
zip  ../release/editor_pi4.zip  ./godot.bs.x11.pi4.opt.tools.32

zip  ../release/export_templates.zip  ./export_templates/*

zip -r ../release/broken_seals_full_source.zip  ./broken_seals_full_source/*
zip -r ../release/broken_seals_game_source.zip  ./broken_seals_game_source/*

cd ..

