# Tools
lipo -create  ../../engine/bin/godot.osx.opt.tools.x86_64 ../../engine/bin/godot.osx.opt.tools.arm64 -output ../../engine/bin/godot.osx.opt.tools.universal
lipo -create  ../../engine/bin/godot.osx.tools.x86_64 ../../engine/bin/godot.osx.tools.arm64 -output ../../engine/bin/godot.osx.tools.universal

