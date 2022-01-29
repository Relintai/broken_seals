rm -Rf ../../engine/bin/Godot.app
cp -r ../../engine/misc/dist/osx_tools.app ../../engine/bin/Godot.app
mkdir -p ../../engine/bin/Godot.app/Contents/MacOS
cp ../../engine/bin/godot.osx.opt.tools.universal ../../engine/bin/Godot.app/Contents/MacOS/Godot
chmod +x ../../engine/bin/Godot.app/Contents/MacOS/Godot

#cd ../../engine/bin/
#zip -q -r Godot.app.zip  Godot.app/*
#cd ../../tools/osx/
