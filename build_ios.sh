# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd ./engine

scons -j6 p=iphone tools=no target=release_debug arch=arm entities_2d=no module_arkit_enabled=no game_center=no
scons -j6 p=iphone tools=no target=release_debug arch=arm64 entities_2d=no module_arkit_enabled=no game_center=no
lipo -create bin/libgodot.iphone.opt.debug.arm.a bin/libgodot.iphone.opt.debug.arm64.a -output bin/libgodot.iphone.debug.fat.a
rm bin/ios_xcode/libgodot.iphone.debug.fat.a
cp bin/libgodot.iphone.debug.fat.a  bin/ios_xcode/libgodot.iphone.debug.fat.a

rm bin/iphone.zip
cd bin/ios_xcode
zip -r -X ../iphone.zip .

cd ..
cd ..
cd ..
