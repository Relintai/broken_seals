cd ../../pandemonium_engine/bin/

files=(
  # Windows
  "pandemonium.windows.opt.64.exe"
  "pandemonium.windows.opt.debug.64.exe"
  "pandemonium.windows.opt.tools.64.exe"
  
  # Linux
  "pandemonium.x11.opt.64"
  "pandemonium.x11.opt.debug.64"
  "pandemonium.x11.opt.tools.64"

  # JS
  "pandemonium.javascript.opt.tools.threads.zip"
  "pandemonium.javascript.opt.zip"
  # Android

  "android_debug.apk"
  "android_release.apk"

  # OSX - Editor
  "Pandemonium.app.zip"

  # OSX - export templates
  "osx.zip"

  # Pi4
  "pandemonium.x11.pi4.opt.32"
  "pandemonium.x11.pi4.opt.debug.32"
  "pandemonium.x11.pi4.opt.tools.32"
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
