# Broken Seals

### The project requires a few custom engine modules to run! read the Editing the game part!

Keep in mind, that most of the work went into the engine modules so far, and the style itself.

A 3D third person RPG. With both multiplayer, and singleplayer capabilities.

The main gameplay-loop goal is to create an experience with enough complexity and depth, that can rival the more old-school MMO- and action rpgs, because nowadays I feel like that is something that got lost.

I want the game to run on every platform, without sacrificing from the gameplay. From the testing I've done this is not even an issue.

This game (with the engine modules) was ported from unity, because it kind of hit the limits of that engine. (Not rendering-wise)

* Basically imagine having about 20 assembly definitions, a main assembly definition, which are just a bunch of interfaces, and everything 
* dependency-injecting itself into it, and still having a 30-ish second compile time, while constantly running into unfixable bugs, and 
* having to work around "simple" problems, like implementing a networking solution on top of LLAPI. Alone.

And the reason for me to tell you is:

-Implementing spells did not get too much priority in this version, meaning like half of them doesn't work at all.
-In the other version I tried to have bindings for controllers, so that they can use lots of spells, it works, and it's not bad at all, but it's not yet implemented into this one. (It was pretty much implemented as bindable control keys)
-Sounds were not implemented at all yet.
-With the graphics I only worked to get the style itself right.

Except for these features however, this version is way more advanced, than the unity one! c++, and godot conventions allowed me to change the code design into something that is pretty much on an another level feature-potential wise.

So it will not take long to implement most if the missing features themselves, as the basic scaffolding is there already.

Now all of these will get higher priority.

## Screenshots

![Initial OS Release Screen 1](screenshots/screen1.png)
![Initial OS Release Screen 2](screenshots/screen2.png)

Note: Before going open source I removed the assets which was derived from paid stuff, which means the game doesn't look like this anymore.
The new textures will need to be cleaned up / improved. It will be done soon. I'll change the screenshots when that's done.
The reason to use these screens is to convey the style I'm going for.

## Editing the game

In order for you to open the game in the editor you will need a custom built version, which can be downloaded from the releases tab, or if you want to build it, chech the Compiling section.

Once you have the proper editor, you should also grab the addons.

You will need scons installed. Scons is required to build godot aswell, so the official godot docs already contain information on how to set it up [here](https://docs.godotengine.org/en/latest/development/compiling/index.html).

in the project's folder call:

``` scons t=all_addons ```

Note that if you built the editor yourself (a.k.a you already ran the command `scons`), you will already have these, and you can skip this step.

## Project architecture

This is the main game, it has scripts so compiling, and setting up the engine is really easy.

To be able to open this project you will need a few engine modules compiled into godot, (The setup script will grab these) namely:

https://github.com/Relintai/world_generator.git

https://github.com/Relintai/entity_spell_system.git

https://github.com/Relintai/ui_extensions.git

https://github.com/Relintai/voxelman.git

https://github.com/Relintai/texture_packer.git

https://github.com/Relintai/godot_fastnoise.git

These modules should be more like core modules. Game specific c++ features will go to a different module. I'll set it up soon.

## Compiling

Before compiling, in the project's folder just run scons, it will set every dependency up. Like:

``` scons ```

I still have the old setup scripts in the repository, in case the scons command fails:
`EngineSetup.bat` on windows, or `engine_setup.sh` on linux/osx.

And then just compile godot as usual. Note I have a bunch of scripts to do it in the root of the project, you can just select the one you need.

[Official docs for compiling GODOT](https://docs.godotengine.org/en/latest/development/compiling/index.html)

## Pulling upstream changes

After you pull changes, just run `scons`, it will update the dependencies.

