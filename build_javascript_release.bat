
cd ./engine

call scons -j6 platform=javascript tools=no target=release entities_2d=no

cd ..