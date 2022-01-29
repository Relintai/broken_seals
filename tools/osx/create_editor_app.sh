cd ../../engine/bin/

rm -Rf Godot.app
rm -f Godot.app.zip

cp -r ../misc/dist/osx_tools.app Godot.app
mkdir -p Godot.app/Contents/MacOS
cp godot.osx.opt.tools.universal Godot.app/Contents/MacOS/Godot
chmod +x Godot.app/Contents/MacOS/Godot

zip -q -r Godot.app.zip  Godot.app/*
cd ../../tools/osx/
