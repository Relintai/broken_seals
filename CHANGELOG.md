# Changelog

All notable changes to this project will be documented in this file.

## [Master]

- Nothing since the last changeset.

## [0.3.12]

#### General

- Created and added a pointing hand cursor.
- Added json serialization support for the data manager addon's settings class.
- Reworked the data_manager addon. Now it stores it's settings using ProjectSettings, so it shouldn't bug out on a fresh import.
- Now dungeons won't get spawned randomly by the zone, instead they are spawned by a new subzone class.
- Set the texture_scale for the test dungeon's TiledWallData to 2.
- Renamed the Godot tab in the about box to Engine.

#### Engine

- Ported my web framework setup from rcpp_framework to a new web module, alongside with lots of improvements to make it fit the engine better. Also implemented a simple webserver that uses built in sockets.
- Ported my database setup from rcpp_framework to a new databases module, alongside with lots of improvements to make it fit the engine better.
- ported my user management setup from rcpp_framework to a new user module, alongside with lots of improvements to make it fit the engine better.
- Created a new cscript module, it's currently only a simplified gdscript implementation.
- Simplified, refactored and ported https://github.com/fenix-hub/godot-engine.file-editor to an engine module. (The refactered gdscript codebase is here: https://github.com/Relintai/godot-engine.file-editor )
- Created a new plugin_refresher module. It can be used to quickly enable / disable addons. You can enable it in the ProjectSettings->Plugins tab. Right click the refresher icon to select the plugin that you want to refresh, left click the same icon to actyally refresh it.
- TiledWalls got a new collider_z_offset property, which allows you to offset the generated collider shape.
- TiledWalls also got a new texture_scaling property. 
- Fixed the 2 add methods in TiledWallData.
- Added a new property hint (PROPERTY_HINT_BUTTON) that can be used with NIL properties to add buttons to the inspector.
- Fixed the property validation for aura triggers and aura stat attributes in Spell.
- Ported all commits that I thought would be useful since the last set of backports from upstream godot 3.x.
- Disabled nullptr modernization in clang tidy.
- Updated the build container scripts.
- Fixed Lights.
- Fixed Codestyle in a few files.
- Lots of TODOs.

## [0.3.11]

#### General

- Moved the animations from the armature_huf scene to just the armature scene.
- Started work on a character editor scene.
- Small improvements to the player character's animations.
- Removed the color palette addon.
- Removed the mesh data resource addon, as the engine now has it built in.
- Added helper script for launching the editor when built with llvm.
- Added a new simple addon, that should help with porting gdscript (my addons -> my codestyle) to cpp.
- Added a scene to cpp conversion tool.
- Removed the gdscript logger singleton and moved to the new engine logger.
- Removed Godoxel. (Now the engine has it built in.)
- Moved most of the project specific helper scripts into the engine's folders.
- Reworked how the project's setup script works internally. Now it's just a thin wrapper that can set up the engine if not present, and it just calls the original script in the engine's folders.
- Added new make_release and export_all scripts, they just call the original scripts in the engine's folders.
- Added TODO.md. I added everything from the TODO issue from github into it.

#### Engine

- Added contains(), find(), and clear() to PoolVector. Also added bindings for them.
- Added a bound core logger class.
- Ported the mesh data editor addon to c++, and now it's a part of the mesh_data_resource module.
- Ported my fork of Godoxel to c++, and now it's part of the engine. (paint module)
- Added a new wfc (WaweFormCollapse) module. I used https://github.com/math-fehr/fast-wfc 's code as a base for it. Samples repository: https://github.com/Relintai/wfc_module_samples
- Ported mat_maker_gd to c++, and now it's part of the engine. (material_maker module)
- Added Z-offset support for TiledWalls. It can be used to offset wall tiles to create 3d wall features. It's missing collider support at the moment.
- Added TODO.md.
- Added some of my game project helper scripts, and made them work from their new place.
- Ported the EditorZoomWidget from Godot4.
- Added frt1 (https://github.com/efornara/frt/tree/1.x).
- Added efornara's frt2 platform. (https://github.com/efornara/frt - 2.0 branch). It won't build when selected right now, due to core changes.
- Removed webp, webm, and the remnants of libvpx, and libwebp, and xatlas modules.
- Fixed low processor mode on android. The fix was inspired by https://github.com/godotengine/godot/pull/59606, although I did it differently.
- Fix compile when using llvm on linux.
- Set Prop2D and Prop module's convert button style to flat, so it's in the expected style.

## [0.3.10]

#### General

- Swapped engines. I created a new, heavily customized godot fork. [Changelog](https://github.com/Relintai/pandemonium_engine/blob/master/CHANGELOG.md)
- Added the world node to the save group. This fixes saving the character on exiting.
- Small improvements to the spell book window.
- Fix material cache initialization logic for the CharacterSkeletonMeshJob.
- Import the weapons and armor pack's textures as packer image resources. This fixes their issues with uvs on the html backend.
- More fixes to the uvs on the html backend.
- Added live version to github.io.
- Added liquids, and a liquid material.
- Created a new water tile.
- Set up a base ocean layer for the world. 
- Raycast from higher up when placing entities. 
- Disabled Octahedral compression for the characters, as it caused issues on some of my test android devices.
- Created a proper icon.
- Various smaller cleanups, and script updates.

#### Tools

- Created a uv debugger tool.
- Added tool keyword to the dungeon teleporters, so they can be spawned in to the editor without errors.

##### World Generator

- Added a new WorldGenRaycast class, and now world generator will use this instead of a stack and stack index to make the data available to the generation methods. Also added local uv to it.
- Implement selecting the edited resource on clicking it's button in the world generator addon's EditorResourceWidget.
- Added a new editor chunk spawn range property to the world. 
- Now the float and int properties use a hbox container, and their label is set to expand fill.
- Modularized the world generation algorithms, so the world is now actually layered.
- Now the default surface's id is customizable in the ocean base world. 
- add_slot in ResourcePropertyList.gd will now return the expected index. 
- Added a h separator to the test continent's properties. 

##### Mat maker GD

- Added undo redo support the gradient editor. This also fixes seamless color editing with it.
- Also added undo redo support fro the gradient editor's interpolation type dropdown.
- Also fixed the gradient editor popup thing. 
- Also added undo redo support for the gradient editor when adding and removing colors.

#### Terraman

- I renamed voxel_surface methods/properties to terra_surface.
- Fixed liquids.
- Added a helper method to the world to get the editor's camera.
- Reworked the in-editor world generation logic. Now when the generate in editor property is set, the world generate chunks around the editor's camera.
-  I fixed a few threading issues when spawning and despawning chunks extremely fast. This happens in the editor when the camera can go around really fast.
- Fixed a typo (transform_uv_scaled used the x coordinate in place of y) This makes the terrain's texture look seamless.
- Now the PCM library generates a liquid material, and also found / fixed a few race conditions.
- Fixed a few issues with material cache usage.
- Fixed color baking lod step when the library supports material caches.

## [0.3.9]

#### General

- Added a `c` build word letter to pass the new `compiledb=yes` to godot's build script.

#### Game

- Reorganized the project's folder structure.
- Created a proper model for the dungeon teleporters. Also fixed their spawn height, and made the terrain smooth under them in the world.
- Now the dungeon teleporters won't all get highlighted when you mouse over one of them.
- The character's skeleton is now not imported, but a native godot scene.
- Converted all 3d models in the project to be native MeshDataResources.
- The keybind text and cooldown count number can be turned off now for the actionbars in the game's settings.
- Fixed the mouse filter of the aura frame. This makes the mouse work again in the top right corner.
- Smaller fixes on the models. Also marked seams on them.

#### Mesh Data Resource Editor addon

- Added the flip face action.
- Added island rotation, and mirroring support to the uv editor.
- Fixed face deletion when more that one faces are selected.
- Fixed normal generation.
- Smaller fixes.

#### Godoxel addon

- Fixed the canvas clipping into other ui elements.
- Fixed the save dialog.

#### Terraman engine module

- Standardized class prefixes to Terrain. For example TerramanLibrary became TerrainLibrary.
- Added a proper readme.md.
- Smaller fixes.

#### Mesh Data Resource engine module

- The importer in it can now save a copy of the imported resource in the project.
- It can now handle meshes with multiple surfaces.
- MeshDataResource now has an `append_arrays()` helper method.
- Smaller fixes to the importer.

## [0.3.8]

### Content creation tools (part 2) - Changes

(I think the content creation tools are now where they should be.)

#### General

- Set up the html5 editor and OSX build, and added it to the releases.
- Updated copyright headers to 2022.
- Re-extract class docs for the engine modules.
- Smaller improvements to the build and release creation scripts.

##### Readme

- Added a status and features section.
- Generic improvements.
- Update the required engine module list.
- Mention that now I use my own fork of godot to have more patches applied.
- Removed the optional patches section, and the patch itself, as it's no longer needed.

#### Mesh Data Resource Editor addon

All important core features got implemented.

- Rotation support.
- Clean mesh algorithm.
- Extrude algorithm.
- Rotation needs to be implemented.
- Pivot point support.
- Improve selection code.
- Face/Edge/Vertex selection support.
- Extrude support.
- Face creation and deletion support.
- Mark / unmark seam support.
- Cut mesh at marked seams action.
- Edges with uv seams are displayed in a different way.
- Improved outline and handle point display support.
- Now handle selection works like how it's expected. e.g. clicking will select one vertex, holding shift will add to it, holding ctrl/alt removes from selection. Also implemented mouse drag  based selection.
- UV editing (Per separate islands.).
- More basic shapes support.
- Multiple mesh data instances editors will work now in one scene.
- Vertex snapping support.
- Add box shape, add triangle, add quad, add triangle to edge, add quad to edge support.
- Undo-Redo support.
- Various improvements and fixes.

#### Data Editor addon

- Renamed my old module_manager addon to this.
- It got a big overhaul.
- It will help with asset organization and quick lookups.
- Now it's settings are stored as a resource instead of a json file.

#### Godoxel addon

- Now if the canvas is behind some other control it properly won't let you draw. Same thing with other tools and zoom.
- Now it will appear as "Paint" on the top of the editor.
- Small improvements.

#### World Generator addon

- Undo-Redo support.
- Small improvements.

#### Mat Maker gd addon

- Undo-Redo support.
- Small improvements.

#### Entity Spell System engine module

- Merged the `Aura` class into the `Spell` class. This will make content creation a lot easier, as you don't need to create both. Also this simplifies even things like spells on items, spell on items in inventory etc.

#### Mesh Utils engine module

- Added the 3d delaunay triangulation implementation from godot4 to it so it's available on 3.x.

## [0.3.7]

### Content creation tools (part 1) - Changes

#### Known issues

All 3 of my addons (mat_maker_gd, world_generator and mesh_data_resource_editor) have problems with letting the editor know when the edited resource changes. I will figure out a how to fix this / what I'm missing for the next release. (I suspect the missing undo-redo support.)

#### General

- Now released filenames contain the version number.
- Improved readme.md a bit.
- Added uv unwrapping support to the mesh_utils module for the mesh_data_resource_editor addon. (I created and added a modified version of xatlas so it just unwraps without creating new seams.)
- Turned TokageItLab's SkeletonEditor (https://github.com/godotengine/godot/pull/45699) to an engine module, with minimal changes to the core in my fork of godot, and switched over the project's engine to this fork.
- Removed the bone editor addon as it's no longer needed.
- Split module information from the main SConstruct file to a separate python file for easier script upgrades.
- Basic networking fix. Still missing some features (For example you won't see animations on clients), and has quite a few bugs, but at least it's working.

#### World generation

Created the new world_generator addon, and implemented everything for it, except for undo/redo.
It has resources that handle the world generation, and an editor for them.

Instead of the old World -> Biomes -> Buildings classes, this addon uses World -> Continent -> Zone -> SubZones.

The idea is that the world is only pseudo-random, so the layout of continents, zones, and subzones have to be set up by hand using rects within an editor, and then these generate the actual 3d representation.

So the terrain will be different based on the given seed, but the spawner locations, zone locations, etc are not (for now at least).

- Ported over the old world generator to the new addon,  and switched to it.
- Removed the world_generator engine module.

#### mat_maker_gd addon

A while ago I started porting (https://github.com/RodZill4/material-maker) to work on the cpu, and inside the editor, but abandoned it for a while.
Not long ago I ended up resurrecting this project, and made it almost feature complete.
It's currently missing ~ 60 from ~ 195 nodes (most should be relatively trivial to do), needs some cleanups, and needs undo-redo support.

- Added it to the project.
- Ported all of the mat maker .ptex files over to mat_maker_gd resources.

#### mesh_data_resource_editor addon

Lots of improvements. Still needs work to be actually usable.

- The gui actually works, and reflects the internal state.
- Vertex, Face, and edge selection modes.
- Proper axis constraint logic.
- Now it can add a box, triangle and quad to the mesh.
- Connect vertex action.
- Various tweaks, code cleanups, and smaller fixes.
- Initial implementation for a uv editor.
- UV unwrapping support via the mesh_utils engine module.

## [v0.3.6]

The changes are still almost entirely technical. This should be the last release of this kind (at least for a while).

-Added a new TiledWall class. It can be used to easily create arbitrarily sized walls using atlas textures.
-The props module can save TiledWalls efficiently into props.
-Added material caching for the props module.
-Finished up the PropInstanceMerger. It supports material caching, generates and uses lod, generates meshes and textures in a different thread, and supports TiledWalls.
-The props module now supports the new rooms and portals system. The system itself still has some issues though.
-Added a class that can procedurally generate buildings from Rooms converted to PropData. It uses serialized portals to connect them. (It's not setting the rooms up for occlusion culling though because the new portals system in godot still has some smaller issues/limitations that prevent this.)
-Spawned a bunch of teleporters to the world with placeholder graphics that create a dungeon when clicked and port the player inside.
-The entity spell system module got material caching support.
-The generated characters now use cached materials.
-The prop converter tool now saves the resources in a way so you don't have to restart the editor for it to pick up the changes.
-Terraman now supports activating/deactivating the world. (Useful when the player is in a dungeon.)
-Reworked MeshDataInstance. Now it uses the VisualServer directly. Also it's a lot more reliable now.
-Fixed a few issues with the mesh utils module.

## [v0.3.5]

Still mostly engine level changes. PropInstanceMerger (=rooms) and Buildings (procedurally generated with portals) are hopefully the last remaining big technical challenges (for a while atleast). I'm hopeful that I can finish these very soon.

Note: The javascript export at the moment has issues with 3d meshes, so I did not add it. It might be a low level godot engine side bug.

-Per chunk material support for terraman (with texture merging).
-Per chunk prop material support for terraman (with texture merging).
-Fixed mesh data instance support for terraman (merged prop meshes).
-Increased the world's scale (voxel_scale property, needs to be renamed.) to 3.
-Started working on the new world generator.
-Added 2 trees from open game art (from https://opengameart.org/content/rpg-item-collection-3). The world generator spawns quite a few from one of it.
-Implemented range checks for Entity interactions.
-The vendor and trainer window will also close when you go too far.
-Added the multirun addon to the project. (Disabled by default)
-Keyboard/controller navigation for the main menu.
-Brought in the player movement code from the tower.
-Jumping. (No animations yet though.)
-Removed the procedural animations module.
-Added a few audio buses. (Although still no audio yet.)
-Optimized the character's mesh.
-Added mesh optmizitation setting to the mesh data resource module. (This reduces the character's vertex count from 1850 to 617 without any visual change.)
-Improvements to PropInstance, although not yet finished.
-Updated/fixed the build containers.
-Removed the -v flag from the editor launch helper script. Not that useful right now.
-A few smaller improvements / build fixes.

## [0.3.4]

-Replaced Voxelman with Terraman. It creates simpler meshes, and it's a lot faster, as it's a terrain engine (int only uses a heightmap), and not a voxel engine (full 3d grid). (The meshes look almost the same.)
-Cleaned up / simplified the world generator module.
-Added build postfixes.
-Lots of work on the mesh data editor plugin.
-Added templates for the pi4, and an editor build.

## [0.3.3.1]

-Fixed hang that sometimes occured during the initial world generation.
-Now lod levels over 4 are supported by default using mesh simplification.
-Now the world will generate 8 lod levels by default.

## [0.3.3]

Note that the voxel engine underwent a bigger refactor, and the initial world generation can get stuck at the moment. This will be fixed later,
if it happens restart the game.

Notable changes:

-Reduced the voxel scale to 2.
-Implemented trainers and vendors.
-Reworked the in-game ui to be modular.
-Every character now has their own actionbars by default.
-Added a new setting to set the current character's actionbars as the default for that class.
-The actionbar now greys out spells that the character doesn't know.
-Implemented texture layering for clothes.
-Smaller bugfixes.
-EntityData cleanups.
-Reworked the meshing for voxelman. Made it more modular.

## [0.3.2]

Notable changes:

-Fixed framerate drops on weaker devices.
-The world's scale is now smaller. (2.6 form 3.0)
-Implemented the character window.
-Added a ui scale option. (With separate values for touchscreens and for desktops.)
-Implemented ingame keybinding settings menu.
-Added the missing icons for the menubar. Also moved it to the bottom left.
-The game will now remember it's window's position and size.
-Speed changing auras are possible now.
-Fixed up most of the setup-related errors with the current character model's animations.
-Now newly spawned mobs will match the player's level (temporarily until better levels are implemented).
-Added a few talents for the naturalist.
-Fixed Nature's Swiftnes.
-Added chunk spawn range, and lod falloff settings.
-Entities are now be placed on the ground after spawn (instead of just falling down).
-MeshDataResources spanning multiple chunks now gets colored aswell (The color is a bit off for now, will be fixed later).
-Smaller ui fixes, and optimizations.

## [0.3.1]

-Fixed the crashes from 0.3.
-A new, very simplistic dungeon generator, and teleporters.
-Small amounts of work on the Naturalist.
-Smaller fixes.

## [0.3]

Still not much, as most of the work went into tech, but you can mess around a little. The next big release (0.4) should be actually playable.

Note that it crashes sometimes when switching scenes (a.k.a. clicking the continue button). This will be fixed. Usually waiting a little bit for the meshes to generate helps.

The broken_seals_game_project.zip is the game folder in the repository (the full source contains this folder aswell).

I uploaded both a release and a debug (release_debug) version for android, as the difference is a lot more noticeable there. The apks work on all 3 (armv7, v8, and x64) architectures.

## [0.01]

Initial open source release

Note: After creation, your character will only know one spell, which is on the second page in the spell book.
(Sorry, sorting haven't been implemented yet)

Sorry no OSX binaries at the moment, the next release will have them as well.
