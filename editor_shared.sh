#!/bin/bash

cp -u ./engine/bin/godot.x11.opt.tools.64 ./engine/bin/run.godot.x11.opt.tools.64


#export LD_LIBRARY_PATH=./engine/bin 
cd ./engine/bin 

export LD_LIBRARY_PATH=.
./run.godot.x11.opt.tools.64 -v
