cd ../../engine/bin/

files=(
  # Windows
  "godot.windows.opt.64.exe"
  "godot.windows.opt.debug.64.exe"
  "godot.windows.opt.tools.64.exe"
  
  # Linux
  "godot.x11.opt.64"
  "godot.x11.opt.debug.64"
  "godot.x11.opt.tools.64"

  # JS
  "godot.javascript.opt.tools.threads.zip"
  "godot.javascript.opt.zip"
  # Android

  "android_debug.apk"
  "android_release.apk"

  # OSX - Editor
  "Godot.app.zip"

  # OSX - export templates
  "osx.zip"

  # Pi4
  "godot.x11.pi4.opt.32"
  "godot.x11.pi4.opt.debug.32"
  "godot.x11.pi4.opt.tools.32"
)

error=0

for f in ${files[*]} 
do
if [ ! -e $f ]; then
  error=1
  echo "$f is not present!"
fi
done

if [ $error -eq 0 ]; then
  echo "All files are present!"
fi

cd ../..
