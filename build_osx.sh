
export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd ./pandemonium_engine

scons -j6 platform=osx target=release_debug 

rm -Rf bin/Godot.app
cp -r misc/dist/osx_tools.app ./bin/Godot.app
mkdir -p ./bin/Godot.app/Contents/MacOS
cp bin/pandemonium.osx.opt.tools.64 bin/Godot.app/Contents/MacOS/Godot
chmod +x bin/Godot.app/Contents/MacOS/Godot

cd ..
