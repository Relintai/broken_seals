rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

@echo off

IF NOT EXIST ./engine (
	git clone https://github.com/godotengine/godot.git ./engine
) ELSE (
	cd engine

	rmdir /s /q modules

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
)

IF EXIST ./modules GOTO DONE
	mkdir modules
:DONE

cd modules

IF NOT EXIST ./fastnoise (
 	git clone https://github.com/Relintai/godot_fastnoise.git fastnoise
) ELSE (
	cd fastnoise

 	git reset --hard
 	git pull origin master
 	git checkout master
 	git reset --hard

 	cd ..
)

xcopy "fastnoise" "../engine/modules/fastnoise" /e /i /h /y

IF NOT EXIST ./ui_extensions (
	git clone https://github.com/Relintai/ui_extensions.git ui_extensions
) ELSE (
	cd ui_extensions

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
)

xcopy "ui_extensions" "../engine/modules/ui_extensions" /e /i /h /y

IF NOT EXIST ./entity_spell_system (
	git clone https://github.com/Relintai/entity_spell_system.git entity_spell_system
) ELSE (
	cd entity_spell_system

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
)

xcopy "entity_spell_system" "../engine/modules/entity_spell_system" /e /i /h /y


IF NOT EXIST ./voxelman (
	git clone https://github.com/Relintai/voxelman.git voxelman
) ELSE (
	cd voxelman

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
)

xcopy "voxelman" "../engine/modules/voxelman" /e /i /h /y


IF NOT EXIST ./world_generator (
	git clone https://github.com/Relintai/world_generator.git world_generator
) ELSE (
	cd world_generator

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
)

xcopy "world_generator" "../engine/modules/world_generator" /e /i /h /y



IF NOT EXIST ./texture_packer (
	git clone https://github.com/Relintai/texture_packer.git texture_packer
) ELSE (
	cd texture_packer

	git reset --hard
	git pull origin master
	git checkout master
	git reset --hard

	cd ..
) 

xcopy "texture_packer" "../engine/modules/texture_packer" /e /i /h /y


cd ..

pause
