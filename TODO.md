#### Next

- Starter gear support.
- Finish character customization support.
- Add support for changing character models temporarily. (Polymorph effects for example.)
- Add a few animals / mobs.
- Add / improve animations.
- Improve the character model.
- Male character model.
- Sounds - basic setup for spell effects, and footsteps.
- Start working on classes.
- Start working on the world, and dungeons.
- I already added Z offsets to TiledWalls, but they still need work to support colliders properly. (Z offset = 3d walls)
- Add a few overworld mobs.
- Set up early levelling.
- Make dungeon spawning manual with the world generator addon.
- Implement Naturalist's spells.
- Add more classes.
- Create some actual proper dungs.
- (Somehow) Figure out the remaining specifics on how the game should actually function. Like pacing, etc.

---

General
======

- Add MIT license headers to files that miss it. (Game)
- Add MIT license headers to files that miss it. (Engine Modules)
- Rebrand this issue as a TODO list, remove checkboxes, and clean it up.
- Set up proper patreon rewards, as it looks super bad right now.
- MIT license headers cleanup.
- Look through the engine module readmes and add links to usage examples. (texture merger could definitely have some of these. Probably more.)
- Set up a a build container for the pi.
- Set up ios build containers and builds.
- Automatically build the server platform aswell for linux.
- Fix compile of the modules for 4.0.
- Check / fix compile of the modules for 3.3, 3.2, and possibly 3.1 and 3.0.
- Look through the engine module readmes and update where necessary. (ESS says it's for godot 3.2, will probably need to update the clone commands aswell.)
- Add a clean script.
- Add a clean - build - release script.
- Add a changelog md file to the repo itself.

---

Animations
========

Animations - Technical
------------------------------

- Figure out a way to set up animation layers so running and attacking at the same time works.
- Make Walk/Run animations faster/slower based on the character's current speed.

Animations
--------------

- Jump - jump
- Jump - falling (loop)
- Jump - land
- Melee - dodge
- Melee - 1h (main hand) - attack
- Melee - 1h (main hand) - miss
- Melee - 1h (main hand) - parry
- Melee - 1h (main hand) - parried
- Melee - 1h (off hand) - attack
- Melee - 1h (off hand) - miss
- Melee - 1h (off hand) - parry
- Melee - 1h (off hand) - block same as parried
- Melee - 2h - attack
- Melee - 2h - miss
- Melee - 2h - blocked - same as parried
- Movement - slow walk
- Movement - walk backwards
- Movement - turn left
- Movement - turn right
- Improve - Movement - run - forward
- Improve - Movement - run - strafe left
- Improve - Movement - run - strafe right
- Improve - Idle
- Improve - Cast - loop
- Improve - Cast - end

---

Characters
========

- Add support for starter items.
- Add starter items.
- Start adding items, and textures for them.
- Start work on classes, add talents etc
- Add more classes.
- Add more spells and talents to the naturalist.
- Actually finish implementing naturalist's spells.
- Set up xp values.
- Make Entities easily creatable from the editor.
- Finish up the EntitySpeciesInstance resource (Maybe this should be renamed). This will make Entities customizable and customizable from the editor.
- Make Entities to automaticaly serialize to props. (This was working at some point.)

---

Models
======

- Male model - It should use the same rig. And even the same parts wherever possible.
- Mob models (Probably 3 should be enough for now) - Spider etc
- Npcs - humanoid variations
- Starter gear support. (Should only need a resource and a few lines of code.)
- Make the model weaponless, by default and equip the initial weapon with starter gear.
- Add clothes to the models with gear. (Npcs could use the same system, it would be easier to make them stronger when needed, in a lot more unique ways than just messing with their hp/damage. Higher resists, or bonuses on equipment etc. (For example different difficulty settings could make their gear better.))

---

Networking
=========

- Fix the animations on the networked entities on clients during movement.
- Fix mouse control / clicking issues when one than one instance is running. (Might be an engine issue, not yet sure.)
- Make sure all remote methods are actually set up as such in Entity.
- A few Entity subsystems need to have rpc calls added. (Vendors for example.)

---

Entities
======

- Check / clean up unneeded properties (if any).

---

Sounds
======

- Implement/add ui sounds
- Implement/add footstep sounds
- Implement/add spell sounds
- Implement/add melee sounds
- Ambient sounds

---

World
=====

Generation
---------------

- Make continents generate terrain with high mountains, or have a zone that does this.
- Figure out a way to make oceans.
- Mob spawners, etc for the world generator.
- Mob level should be based off of the player's level after every load. At least for now.
- Save mobs - or have and save respawn timers.

Technical
------------

- Save chunks, so they don't have to be re-generated every time. (Potentially also save and cache chunk meshes.)

Buildings
------------

- Exclude/include spawn support for the props module. (This is more general than the random spawn support, this system could do that too.) For example prop_instance->set_skip_spawn(int prop_entry_index, true/false), and store additional info in prop data entries, like chance to spawn etc, and Building could set these based on what it wants. This solution would also work with plugs.
- Finish portal support. (Need to check whether the system works now properly or not.)
- Spawn in buildings in the proper way for the portal culling system. (After it actually starts to work with custom geometry instances, or it's notifications starts to work.)
- Start adding props, and start actually working on dungeons.

---

Content Creation Tools
=================

- Make sure repositories exist for all the current addons, and also update/add them there.

mesh_data_resource_editor
-------------------------------------

- Set position widget.
- Snapping support via a popup + snap to button.
- Snapping support while dragging.
- Blender like move by "x" type command.
- Add translate by, scale by, rotate by widgets to the sidebar. -> gets zeroed on deselection. -> undo redo on deselection.
- A small overlay telling some infos, like vert positions etc.
- Port it to c++ and add it to the mesh_data_resource module by default.

mat_maker_gd
--------------------

( https://github.com/Relintai/mat_maker_gd ) A port of https://github.com/RodZill4/material-maker to work on the cpu, and inside the editor as a module. I already ported most of the shaders to gdscript. I'm adding this now as it's development is not that demanding, and I can mess with this during times where I wouldn't really be able to do much else.

- Go through the current MaterialMaker and add the code from all the new nodes.
- Go through the current MaterialMaker and update any old code.
- Add note to all files that has code from MaterialMaker.
- Proper readme.md.
- Per node seed like in the original.
- Port all the nodes. Missing ~ 60 from ~ 195
- Add threading support when ThreadPool is not available.
- Figure out a way to have it working on vanilla godot, wihtout changes.
- Try to fix error spam that sometimes happen on undo.
- Should probably be submitted to the assetlib.
- Comment cleanups.
- Figure out which commit I used as a base and add it to the readme. - Or just bring back the .mmgd sets, update them and update comments wherever necessary.

Eventually turn it into an engine module once it works properly, and proven to be useful.

---

UI
==

- Ingame controller navigation support for the windows.
- Ingame controller spell dragging support.
- Bindable custom modifiers support for the spells. It would allow you to create new shift/alt/etc like keys and bind buttons to them. I tested this a while ago with a previous version in Unity. Works really well for contollers.
- Set up a supporters section in the about dialog.

---

Technical
========

- Finish collision support for TiledWalls.
- TerramanMaterialCache duplicates materials in a different thread. This can cause crashes (fortunately it happens rarely), so figure out a way to make the material duplication itself happen on the main thread without too much complications.
- The character has some texture mapping issues on the javascipt backend. Fix.

---

Project
=====

- Reorganize the project's folders, and remove the modules folder.

---

Documentation
============

Modules
-----------

- Improve docs.
- Most modules need a lot more docs. 
- ESS needs a lot more docs about the character skeleton setup / character mesh merges.

---

Notes
=====

Everything below this point are random ideas / things that might be needed in the future (Even though they have formatting that might make it seem otherwise.)
This stuff needs to be cleaned up.


Random item /scene, prop, mesh etc/ spawning support for the prop system -> depends on how the room and building system will end up.
Tooling for easy room creation -> currently I think a class that can tile walls with texture atlas textures + the prop system + an in engine editor for it should be enough (Basicly a spatial node that has 4 vertices, and it creates a tiled mesh with a given texture between those vertices + can be used and serialized to and merged from a prop, without node creation)
Auto attack (I used to be against this, but not sure anymore. Thinking about it.)
Maybe an alternate clothing system for npcs, so they don't need gear.

 Finish pet support.
Pet talents.

Later

Make the models by default naked. This is not that important for now (except for the weapons).
Terraman raw chunk data serialization (For mostly other games).
Mesh cache support for Terraman. (It could save generated meshes, and stuff like spawn data to the disk, instead of raw chunk data, since terrains aren't editable in this game.)
Full world pre-generation option. (After the new world generator is finished, since It won't generate "infinite" terrains)
Finish the mesh data editor plugin.

Togglable spells. (Auto attack, auto shoot etc)(?)

Fix Networking.
Terraman networking support. (Just keeping the chunks loaded around all players serverside should be enough for now.)
Doing these should be relatively simple after the world related things are finished. Like dungeons/buildings etc as these need some experimentation.
AO fix/reimplementation for PropInstanceMerger.
Vertex light fix/reimplementation for Terraman.
Add random spawn support to the prop system.
Controller support for spells. (It works by default, but need to have bindable custom modifiers to be usable. (Bindable custom shift, alt etc like keys.)
Add a chat
Add command support to the chat
Add serverside commands
Make the ui navigatable via the keyboard / controller ingame.

A music player that can play files from a folder. Could support dynamic music with subfolders. Like it could play music from a battle subfolder in combat etc.

"Stretchable" wall that serializes to and from props and creates a proper mesh grid on deserialization/in the editor. (They cold have 4 vertices -> they could use the portal editor. -> could be a setting. Also vertex snapping in editor maybe.)
"Stretchable" wall with multiple textures. (Vector (tex) -> random/tiled -multiple way- order)
Animation - emotes

PropInstanceMerger should use rooms and portals callbacks. Those callbacks doesn't yet work properly.
 Finish up EntitySpeciesInstance -> so entities can be customized -> like having different hair styles / faces / skin color etc
Figure out a way to set up animation layers so running and casting at the same time works.

Implement world saves (Might be a good candidate for the 0.5 release):
---------------------------------------------------------------------------------------

Save which mobs get killed and don't spawn them back on chunk/dungeon reload.
Implement character position save.
Implement character position save even in a dungeon.
Save all generated world data, so it won't have to be generated more than once. (Makes position saves easier.)
Save all generated meshes aswell, and just load them if they exist. (Maybe this should be done after 0.4.)
Have a way to reset the world. (Or have respawns on a timer.) (Or just respawn mobs after quitting.)

---
Other queued up stuff / stuff that I'm thinking about:

Create an asset store like editor plugin, which handles game modules. Should also save dependencies, and git commit hashes.
Optionally implement this into the project setup script.
Add more hooks to modules.
Add optional init order priority for modules.
Add module dependencies.
Edit time hooks/init for modules. (?) - Would remove lots of complexity from game startup. - Could be awful for git and development though. - Will need to think. Zero conf modules would be preferrable.
Take modules and put them into separate repositories.
Specialized modules (?) (For example terrarin generation, ui, etc.)

Plug support for the prop system? PropDataMerger could have an api for this set_render_plug(PropDataPortal, bool).
Setting up tiles like that however would be annoying. It might be simpler to have plugs in the building class, and that plugs up holes if the generator can't spawn a proper room. It should spawn end rooms when it can.

Fixes

Fix Networking.
Voxelman networking support. (Just keeping the chunks loaded around all players serverside should be enough for now.)

Usability

Make Entities saveable with scenes. (Mostly done, should only need fixes.)
Entity spawner prop for voxelman.
Voxelman different per channel size support. (maybe)
A terrarin engine like voxel mesher for voxelman. (it could operate on a for example 16x16x1 array.)
A terrarin engine like water support for voxelman.
A terrarin engine like editor tools for voxelman.
Improve the voxel editors.
Fix VoxelMesherCubic.
Editor tools for VoxelMesherCubic.
Implement hide option for voxel faces.
Editor tools for voxel lights.
Prop toolbar.
Fix save issues with the procedural animations module. Or maybe drop it?
Ability to serialize meshes into chunks.
Ability to export chunks with only mesh data.
Ability to pre-bake everything into chunks.
Ability for voxelman to save and load chunks automatically from files.
The data editor plugin should probably be fixed/improved.

Other

Drop procedural generation(?) (Still not 100% sure.) Handcrafted content usually works better for rpgs. Could be done for a test project.

From the old issue: (Will be cleaned up soon.)

---
Classes

Fix/implement all of Naturalist's spells
Add more talents for Naturalist
Add more classes (at least 2 for now)

---
Models / animations

Add a human male model
Make the human female model look less bad
(Maybe) add more races
Add / create animal models
Create melee animations
Implement melee attack animations (godot side) - Needs animation blending/layers too
Add variations for the human


---
Outdoor props

Add a few basic props like trees, bushes, (maybe) flowers, fences etc.
Create a few buildings. Maybe these could be procedurally generated using the prop system.
This system could also do smaller outdoor "dungeons" like forts for example.

---
Level generation

Implement continent generation.
Villages.
More biomes.
Add simple cave generation. (Should be easy compared to full dungeons.)
Implement quests.
Very simple quest generation.

~~Create a simple scenario / planet with a dungeon (Diablo 1 complexity should be enough for now (I mean a small town and a multilevel dungeon), especially since the class design/combat design needs to be kind of like... found).~~ (I think I might be able to do the continent generator directly.)

---
Mobs
Add wild animals (at least a few)
Add mobs - camps, forts bandits etc -
Fix mob turning

---
Items
Basic crafting materials
Basic weapons / clothes
Starter items
Maybe a few simple crafting recipes
---
Gameplay
Need more experiments, both combat and the overall map design

---
Development quality of life (These would make creating models with the current style a breeze)
Finish the mesh data resource editor addon. Not having to export bodyparts constantly would make life a lot easier. Editing models inside the world with the generated terrarin (with the ingame colors/look) would be cool aswell.
~Improve gdpose. Would make it simpler to mess with animations, as with the current workflow you can't see the final model in blender, only a skeleton.~ Turns out the [skeleton editor backport](https://github.com/godotengine/godot/pull/45699) already works quite well,  added it as a patch.

---
### Later

Dungeons (Can easily be a goal for 0.5. Especially if the continent generation works out. They will still require lots of work, even though Voxelman already supports them. Unfortunately right now the core is better equipped to work with an overworld.)

 A few basic dungeon props (Can't tell exactly yet, depends on the dungeon generator)
Create an okay dungeon generator.
(Probably) A new voxel mesher that works like VoxelMesherBlocky, but also uses isolevel.
Try vertex displacement based on a global noise (per mesher). This might make everything look more organic.
Empty voxel. A voxel type that makes Voxelman skip generating it's mesh.
Mobs for the dungeons.

---
Networking
Fix Networking
Maybe a client should receive terrarin data from the server. This would make the terrarin editable serverside. It would also reduce client only computation.

Is shouldn't be that hard to fix, but it will need some work. Can probably wait until the game is actually somewhat playable.

---
Development quality of life (These would make creating models with the current style a breeze)
Implement vertex edit mode for skeletons -> Depends on the mdr editor addon. (Not as important, not having to export after every change is the real time save)
Finish, and port math_maker_gd to c++. (Not as important)
