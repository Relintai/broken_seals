#!/bin/bash

cp -u ./pandemonium_engine/bin/godot.x11.opt.tools.64 ./pandemonium_engine/bin/run.godot.x11.opt.tools.64

export LD_LIBRARY_PATH=`pwd`/pandemonium_engine/bin/
./pandemonium_engine/bin/run.godot.x11.opt.tools.64 -e --path ./game/
