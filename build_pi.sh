
scons bel_latomic_strip_slim -j4
scons bl_latomic_strip_slim -j4
scons blr_latomic_strip_slim -j4

rm -f ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.32 
rm -f ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.debug.32
rm -f ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.tools.32

mv ./pandemonium_engine/bin/pandemonium.x11.opt.32 ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.32 
mv ./pandemonium_engine/bin/pandemonium.x11.opt.debug.32 ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.debug.32
mv ./pandemonium_engine/bin/pandemonium.x11.opt.tools.32 ./pandemonium_engine/bin/pandemonium.x11.pi4.opt.tools.32
