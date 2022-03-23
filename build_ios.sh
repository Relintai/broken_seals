
export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd ./pandemonium_engine

scons -j6 p=iphone tools=no target=release_debug arch=arm module_arkit_enabled=no game_center=no
scons -j6 p=iphone tools=no target=release_debug arch=arm64 module_arkit_enabled=no game_center=no
lipo -create bin/libpandemonium.iphone.opt.debug.arm.a bin/libpandemonium.iphone.opt.debug.arm64.a -output bin/libpandemonium.iphone.debug.fat.a
rm bin/ios_xcode/libpandemonium.iphone.debug.fat.a
cp bin/libpandemonium.iphone.debug.fat.a  bin/ios_xcode/libpandemonium.iphone.debug.fat.a

rm bin/iphone.zip
cd bin/ios_xcode
zip -r -X ../iphone.zip .

cd ..
cd ..
cd ..
