#!/usr/bin/env python

# Copyright (c) 2019-2020 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

EnsureSConsVersion(0, 98, 1)

import sys
import os
import subprocess
import json
import shutil
import traceback

repository_index = 0
module_clone_path  = '/modules/' 
clone_command = 'git clone {0} {1}'

engine_repository = [ ['https://github.com/godotengine/godot.git', 'git@github.com:godotengine/godot.git'], 'engine', '' ]

module_repositories = [
    [ ['https://github.com/Relintai/world_generator.git', 'git@github.com:Relintai/world_generator.git'], 'world_generator', '' ],
    [ ['https://github.com/Relintai/entity_spell_system.git', 'git@github.com:Relintai/entity_spell_system.git'], 'entity_spell_system', '' ],
    [ ['https://github.com/Relintai/ui_extensions.git', 'git@github.com:Relintai/ui_extensions.git'], 'ui_extensions', '' ],
    [ ['https://github.com/Relintai/voxelman.git', 'git@github.com:Relintai/voxelman.git'], 'voxelman', '' ],
    [ ['https://github.com/Relintai/texture_packer.git', 'git@github.com:Relintai/texture_packer.git'], 'texture_packer', '' ],
    [ ['https://github.com/Relintai/godot_fastnoise.git', 'git@github.com:Relintai/godot_fastnoise.git'], 'fastnoise', '' ],
    [ ['https://github.com/Relintai/mesh_data_resource.git', 'git@github.com:Relintai/mesh_data_resource.git'], 'mesh_data_resource', '' ],
    [ ['https://github.com/Relintai/procedural_animations.git', 'git@github.com:Relintai/procedural_animations.git'], 'procedural_animations', '' ],
    [ ['https://github.com/Relintai/props.git', 'git@github.com:Relintai/props.git'], 'props', '' ],
    [ ['https://github.com/Relintai/mesh_utils.git', 'git@github.com:Relintai/mesh_utils.git'], 'mesh_utils', '' ],
    [ ['https://github.com/Relintai/broken_seals_module.git', 'git@github.com:Relintai/broken_seals_module.git'], 'broken_seals_module', '' ],
]

addon_repositories = [
]

third_party_addon_repositories = [
]

target_commits = {}

godot_branch = '3.2'

def onerror(func, path, exc_info):
    """
    https://stackoverflow.com/questions/2656322/shutil-rmtree-fails-on-windows-with-access-is-denied

    Because Windows.

    Error handler for ``shutil.rmtree``.

    If the error is due to an access error (read only file)
    it attempts to add write permission and then retries.

    If the error is for another reason it re-raises the error.

    Usage : ``shutil.rmtree(path, onerror=onerror)``
    """
    import stat
    if not os.access(path, os.W_OK):
        # Is the error an access error ?
        os.chmod(path, stat.S_IWUSR)
        func(path)
    else:
        raise

def load_target_commits_array():
    global target_commits

    if os.path.isfile('./HEADS'):
        with open('./HEADS', 'r') as infile:
            target_commits = json.load(infile)
    else:
        target_commits = {}

def save_target_commits_array():
    with open('./HEADS', 'w') as outfile:
        json.dump(target_commits, outfile)

def update_repository(data, clone_path, branch = 'master'):
    cwd = os.getcwd()

    full_path = cwd + clone_path + data[1] + '/'
    
    if not os.path.isdir(full_path):
        os.chdir(cwd + clone_path)

        subprocess.call(clone_command.format(data[0][repository_index], data[1]), shell=True)

    os.chdir(full_path)

    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)
    subprocess.call('git clean -f -d', shell=True)
    subprocess.call('git checkout -B ' + branch + ' origin/' + branch, shell=True)
    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)
    subprocess.call('git clean -f -d', shell=True)
    subprocess.call('git pull origin ' + branch, shell=True)

    process = subprocess.Popen('git rev-parse HEAD', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = process.communicate()[0].decode().strip()

    if data[1] not in target_commits:
        target_commits[data[1]] = {}

    target_commits[data[1]][branch] = output

    os.chdir(cwd)

def setup_repository(data, clone_path, branch = 'master'):
    cwd = os.getcwd()

    full_path = cwd + clone_path + data[1] + '/'
    
    if not os.path.isdir(full_path):
        os.chdir(cwd + clone_path)

        subprocess.call(clone_command.format(data[0][repository_index], data[1]), shell=True)

    os.chdir(full_path)

    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)
    subprocess.call('git clean -f -d', shell=True)
    subprocess.call('git checkout -B ' + branch + ' origin/' + branch, shell=True)
    subprocess.call('git pull origin master', shell=True)

    if data[1] in target_commits:
        target = target_commits[data[1]][branch]

    subprocess.call('git checkout -B ' + branch + ' ' + target, shell=True)
    subprocess.call('git clean -f -d', shell=True)
    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)

    os.chdir(cwd)

def copy_repository(data, target_folder, clone_path):
    copytree(os.path.abspath(clone_path + data[1] + '/' + data[2]), os.path.abspath(target_folder + data[1]))

def copytree(src, dst):
    for item in os.listdir(src):
        sp = os.path.join(src, item)
        dp = os.path.join(dst, item)

        if os.path.isdir(sp):
            if os.path.isdir(dp):
                shutil.rmtree(dp, onerror=onerror)

                shutil.copytree(sp, dp)
        else:
            if not os.path.isdir(dst):
                os.makedirs(dst)

            shutil.copy2(sp, dp)

def update_engine():
    update_repository(engine_repository, '/', godot_branch)

def update_modules():
    for rep in module_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './engine/modules/', '.' + module_clone_path)

def update_addons():
    for rep in addon_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def update_addons_third_party_addons():
    for rep in third_party_addon_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def update_all():
    update_engine()
    update_modules()
    update_addons()
    update_addons_third_party_addons()

    save_target_commits_array()


def setup_engine():
    setup_repository(engine_repository, '/', godot_branch)

def setup_modules():
    for rep in module_repositories:
        setup_repository(rep, module_clone_path)
        copy_repository(rep, './engine/modules/', '.' + module_clone_path)

def setup_addons():
    for rep in addon_repositories:
        setup_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def setup_addons_third_party_addons():
    for rep in third_party_addon_repositories:
        setup_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def setup_all():
    setup_engine()
    setup_modules()
    setup_addons()
    setup_addons_third_party_addons()


env = Environment()

if len(sys.argv) > 1:

    arg = sys.argv[1]

    if arg[0] == 'b':
        build_string = 'scons '

        build_string += 'tools='
        if 'e' in arg:
            build_string += 'yes'
        else:
            build_string += 'no'
        build_string += ' '

        build_string += 'target='
        if 'r' in arg:
            build_string += 'release'
        elif 'd' in arg:
            build_string += 'debug'
        else:
            build_string += 'release_debug'
        build_string += ' '

        build_string += 'custom_modules_shared='
        if 's' in arg:
            build_string += 'yes'
        else:
            build_string += 'no'
        build_string += ' '

        if 'm' in arg:
            build_string += 'use_mingw=yes'
        else:
            if 'win' in sys.platform:
                build_string = 'call "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat" amd64&' + build_string

        if 'o' in arg:
            build_string += 'use_llvm=yes'

        if 'v' in arg:
            build_string += 'vsproj=yes'

        for i in range(2, len(sys.argv)):
            build_string += ' ' + sys.argv[i] + ' '

        target = ' '

        if 'E' in arg:
            target += 'bin/libess.x11.opt.tools.64.so'
        elif 'T' in arg:
            target += 'bin/libtexture_packer.x11.opt.tools.64.so'
        elif 'V' in arg:
            target += 'bin/libvoxelman.x11.opt.tools.64.so'
        elif 'W' in arg:
            target += 'bin/libworld_generator.x11.opt.tools.64.so'
        elif 'P' in arg:
            target += 'bin/libprocedural_animations.x11.opt.tools.64.so'
        elif 'M' in arg:
            target += 'bin/libfqms.x11.opt.tools.64.so'

        print('Running command: ' + build_string)

        cwd = os.getcwd()
        full_path = cwd + '/engine/'

        if not os.path.isdir(full_path):
            print('engine directory doesnt exists.')
            exit()

        os.chdir(full_path)

        cache_exports_str = 'export SCONS_CACHE=~/.scons_cache;export SCONS_CACHE_LIMIT=5000;'

        if 'win' in sys.platform:
            cache_exports_str = 'set SCONS_CACHE=%userprofile%\\.scons_cache\\&set SCONS_CACHE_LIMIT=5000&'

        if 'l' in arg:
            build_string += 'platform=x11'

            subprocess.call(cache_exports_str + build_string + target, shell=True)
        elif 'w' in arg:
            build_string += 'platform=windows'

            subprocess.call(cache_exports_str + build_string, shell=True)
        elif 'a' in arg:
            build_string += 'platform=android'

            android_exports_str = 'export ANDROID_NDK_ROOT=~/SDKs/Android/NDK/android-ndk-r20b;export ANDROID_NDK_HOME=~/SDKs/Android/NDK/android-ndk-r20b;export ANDROID_HOME=~/SDKs/Android/SDK;'

            if 'win' in sys.platform:
                android_exports_str = 'set ANDROID_NDK_ROOT=%userprofile%/SDKs/Android/NDK/android-ndk-r20b&set ANDROID_NDK_HOME=%userprofile%/SDKs/Android/NDK/android-ndk-r20b&set ANDROID_HOME=%userprofile%/SDKs/Android/SDK&'

            subprocess.call(cache_exports_str + android_exports_str + build_string + ' android_arch=armv7', shell=True)
            subprocess.call(cache_exports_str + android_exports_str + build_string + ' android_arch=arm64v8', shell=True)
            subprocess.call(cache_exports_str + android_exports_str + build_string + ' android_arch=x86', shell=True)

            os.chdir(full_path + 'platform/android/java/')

            subprocess.call(cache_exports_str + android_exports_str + './gradlew generateGodotTemplates', shell=True)
        elif 'j' in arg:
            build_string += 'platform=javascript'

            subprocess.call(cache_exports_str + build_string, shell=True)
        elif 'i' in arg:
            build_string += 'platform=iphone'

            subprocess.call(cache_exports_str + build_string + ' arch=arm', shell=True)
            subprocess.call(cache_exports_str + build_string + ' arch=arm64', shell=True)

            #subprocess.call('lipo -create bin/libgodot.iphone.{0}.arm.a bin/libgodot.iphone.{0}.arm64.a -output bin/libgodot.iphone.{1}.fat.a'.fomat(), shell=True)

            #lipo -create bin/libgodot.iphone.opt.debug.arm.a bin/libgodot.iphone.opt.debug.arm64.a -output bin/libgodot.iphone.debug.fat.a
            #rm bin/ios_xcode/libgodot.iphone.debug.fat.a
            #cp bin/libgodot.iphone.debug.fat.a  bin/ios_xcode/libgodot.iphone.debug.fat.a

            #lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a -output bin/libgodot.iphone.release.fat.a
            #rm bin/ios_xcode/libgodot.iphone.release.fat.a
            #cp bin/libgodot.iphone.release.fat.a  bin/ios_xcode/libgodot.iphone.release.fat.a

            subprocess.call('rm bin/iphone.zip', shell=True)
            #cd bin/ios_xcode
            subprocess.call(cache_exports_str + build_string + ' arch=arm64', shell=True)
            subprocess.call('zip -r -X ../iphone.zip .', shell=True)

        else:
            print('No platform specified')
            exit()

        exit()
    elif arg[0] == 'p':
        if arg == 'p':
            print("Applies a patch. Append c for the compilation database patch. For example: pc")
            exit()

        cwd = os.getcwd()
        full_path = cwd + '/engine/'

        if not os.path.isdir(full_path):
            print('engine directory doesnt exists.')
            exit()

        os.chdir(full_path)

        #apply the patch to just the working directory, without creating a commit

        if 'c' in arg:
            subprocess.call('git apply --index ../patches/compilation_db.patch', shell=True)

        #unstage all files
        subprocess.call('git reset', shell=True)

        exit()

opts = Variables(args=ARGUMENTS)

opts.Add('a', 'What to do', '')
opts.Add(EnumVariable('action', 'What to do', 'setup', ('setup', 'update')))
opts.Add('t', 'Action target', '')
opts.Add(EnumVariable('target', 'Action target', 'all', ('all', 'engine', 'modules', 'all_addons', 'addons', 'third_party_addons')))
opts.Add(EnumVariable('repository_type', 'Type of repositories to clone from first', 'http', ('http', 'ssh')))

opts.Update(env)
Help(opts.GenerateHelpText(env))

load_target_commits_array()

rt = env['repository_type']

if rt == 'ssh':
    repository_index = 1

action = env['action']
target = env['target']

if env['a']:
    action = env['a']

if env['t']:
    target = env['t']

if not os.path.isdir('./modules'):
    os.mkdir('./modules')

if 'm' in action:
    godot_branch = 'master'

if 'setup' in action or action[0] == 's':
    if target == 'all':
        setup_all()
    elif target == 'engine':
        setup_engine()
    elif target == 'modules':
        setup_modules()
    elif target == 'all_addons':
        setup_addons()
        setup_addons_third_party_addons()
    elif target == 'addons':
        setup_addons()
    elif target == 'third_party_addons':
        setup_addons_third_party_addons()
elif 'update' in action or action[0] == 'u':
    if target == 'all':
        update_all()
    elif target == 'engine':
        update_engine()
        save_target_commits_array()
    elif target == 'modules':
        update_modules()
        save_target_commits_array()
    elif target == 'all_addons':
        update_addons()
        update_addons_third_party_addons()
        save_target_commits_array()
    elif target == 'addons':
        update_addons()
        save_target_commits_array()
    elif target == 'third_party_addons':
        update_addons_third_party_addons()
        save_target_commits_array()
        
