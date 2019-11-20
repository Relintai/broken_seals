#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

if [ ! -d engine ]; then
	git clone https://github.com/godotengine/godot.git ./engine
else
	cd engine

	rm -Rf modules

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
fi

if [ ! -d modules ]; then
	mkdir modules
fi

cd modules

if [ ! -d fastnoise ]; then
	git clone https://github.com/Relintai/godot_fastnoise.git ./fastnoise
	cp -R  ./fastnoise ../engine/modules/fastnoise
else
	cd fastnoise

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R  ./fastnoise ../engine/modules/fastnoise
fi

if [ ! -d ui_extensions ]; then
	git clone git@github.com:Relintai/ui_extensions.git ui_extensions
	cp -R ./ui_extensions  ../engine/modules/ui_extensions
else
	cd ui_extensions

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R ./ui_extensions  ../engine/modules/ui_extensions
fi

if [ ! -d entity_spell_system ]; then
	git clone git@github.com:Relintai/entity_spell_system.git entity_spell_system
	cp -R ./entity_spell_system  ../engine/modules/entity_spell_system
else
	cd entity_spell_system

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R ./entity_spell_system  ../engine/modules/entity_spell_system
fi

if [ ! -d voxelman ]; then
	git clone git@github.com:Relintai/voxelman.git voxelman
	cp -R ./voxelman  ../engine/modules/voxelman
else
	cd voxelman

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R ./voxelman  ../engine/modules/voxelman
fi

if [ ! -d world_generator ]; then
	git clone git@github.com:Relintai/world_generator.git world_generator
	cp -R ./world_generator  ../engine/modules/world_generator
else
	cd world_generator

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R ./world_generator  ../engine/modules/world_generator
fi

if [ ! -d texture_packer ]; then
	git clone git@github.com:Relintai/texture_packer.git texture_packer
	cp -R ./texture_packer  ../engine/modules/texture_packer
else
	cd texture_packer

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..

	cp -R ./texture_packer  ../engine/modules/texture_packer
fi

