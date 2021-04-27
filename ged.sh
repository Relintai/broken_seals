#!/bin/bash

cp -u ./engine/bin/godot.x11.opt.tools.64 ./engine/bin/run.godot.x11.opt.tools.64

export LD_LIBRARY_PATH=`pwd`/engine/bin/
./engine/bin/run.godot.x11.opt.tools.64 -e --path ./game/
