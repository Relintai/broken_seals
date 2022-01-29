#templates

cd ../../engine/bin

cp -r ../misc/dist/osx_template.app .
mkdir -p osx_template.app/Contents/MacOS
cp godot.osx.opt.universal osx_template.app/Contents/MacOS/godot_osx_release.64
cp godot.osx.opt.debug.universal osx_template.app/Contents/MacOS/godot_osx_debug.64
chmod +x osx_template.app/Contents/MacOS/godot_osx*
zip -q -9 -r osx.zip osx_template.app

cd ../../tools/osx
