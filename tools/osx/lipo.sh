# Tools
lipo -create  ../../pandemonium_engine/bin/pandemonium.osx.opt.tools.x86_64 ../../pandemonium_engine/bin/pandemonium.osx.opt.tools.arm64 -output ../../pandemonium_engine/bin/pandemonium.osx.opt.tools.universal

# Export Templates
lipo -create  ../../pandemonium_engine/bin/pandemonium.osx.opt.x86_64 ../../pandemonium_engine/bin/pandemonium.osx.opt.arm64 -output ../../pandemonium_engine/bin/pandemonium.osx.opt.universal
lipo -create  ../../pandemonium_engine/bin/pandemonium.osx.opt.debug.x86_64 ../../pandemonium_engine/bin/pandemonium.osx.opt.debug.arm64 -output ../../pandemonium_engine/bin/pandemonium.osx.opt.debug.universal
