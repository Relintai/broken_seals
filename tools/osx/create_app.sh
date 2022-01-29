rm -Rf ../../engine/bin/Godot.app
cp -r ../../engine/misc/dist/osx_tools.app ../../engine/bin/Godot.app
mkdir -p ../../engine/bin/Godot.app/Contents/MacOS
cp ../../engine/bin/godot.osx.opt.tools.universal ../../engine/bin/Godot.app/Contents/MacOS/Godot
chmod +x ../../engine/bin/Godot.app/Contents/MacOS/Godot
cd ../../engine/bin/
zip -q -r Godot.app.zip  Godot.app/*
cd ../../tools/osx/

#templates
#cp -r misc/dist/osx_template.app .
#mkdir -p osx_template.app/Contents/MacOS
#cp bin/godot.osx.opt.universal osx_template.app/Contents/MacOS/godot_osx_release.64
#cp bin/godot.osx.opt.debug.universal osx_template.app/Contents/MacOS/godot_osx_debug.64
#chmod +x osx_template.app/Contents/MacOS/godot_osx*
#zip -q -9 -r osx.zip osx_template.app

