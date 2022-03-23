#templates

cd ../../pandemonium_engine/bin

cp -r ../misc/dist/osx_template.app .
mkdir -p osx_template.app/Contents/MacOS
cp pandemonium.osx.opt.universal osx_template.app/Contents/MacOS/pandemonium_osx_release.64
cp pandemonium.osx.opt.debug.universal osx_template.app/Contents/MacOS/pandemonium_osx_debug.64
chmod +x osx_template.app/Contents/MacOS/pandemonium_osx*
zip -q -9 -r osx.zip osx_template.app

cd ../../tools/osx
