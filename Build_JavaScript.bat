
cd ./engine

call scons -j2 platform=javascript tools=no target=release_debug entities_2d=no

cd ..
