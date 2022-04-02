#!/bin/bash

cp -u ./pandemonium_engine/bin/pandemonium.x11.opt.tools.64.llvm ./pandemonium_engine/bin/run.pandemonium.x11.opt.tools.64.llvm

export LD_LIBRARY_PATH=`pwd`/pandemonium_engine/bin/
./pandemonium_engine/bin/run.pandemonium.x11.opt.tools.64.llvm -e --path ./game/
