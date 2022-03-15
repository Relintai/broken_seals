# Tools
lipo -create  ../../pandemonium_engine/bin/godot.osx.opt.tools.x86_64 ../../pandemonium_engine/bin/godot.osx.opt.tools.arm64 -output ../../pandemonium_engine/bin/godot.osx.opt.tools.universal

# Export Templates
lipo -create  ../../pandemonium_engine/bin/godot.osx.opt.x86_64 ../../pandemonium_engine/bin/godot.osx.opt.arm64 -output ../../pandemonium_engine/bin/godot.osx.opt.universal
lipo -create  ../../pandemonium_engine/bin/godot.osx.opt.debug.x86_64 ../../pandemonium_engine/bin/godot.osx.opt.debug.arm64 -output ../../pandemonium_engine/bin/godot.osx.opt.debug.universal
