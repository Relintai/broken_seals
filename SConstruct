#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2019-2021 Péter Magyar
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

visual_studio_call_vcvarsall = False
visual_studio_vcvarsall_path = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat'
visual_studio_arch = 'amd64'

exports = {
    'global': [],
    'linux': [],
    'windows': [],
    'android': [],
    'javascript': [],
}

engine_repository = [ ['https://github.com/godotengine/godot.git', 'git@github.com:godotengine/godot.git'], 'engine', '' ]

module_repositories = [
    [ ['https://github.com/Relintai/world_generator.git', 'git@github.com:Relintai/world_generator.git'], 'world_generator', '' ],
    [ ['https://github.com/Relintai/entity_spell_system.git', 'git@github.com:Relintai/entity_spell_system.git'], 'entity_spell_system', '' ],
    [ ['https://github.com/Relintai/ui_extensions.git', 'git@github.com:Relintai/ui_extensions.git'], 'ui_extensions', '' ],
    [ ['https://github.com/Relintai/texture_packer.git', 'git@github.com:Relintai/texture_packer.git'], 'texture_packer', '' ],
    [ ['https://github.com/Relintai/godot_fastnoise.git', 'git@github.com:Relintai/godot_fastnoise.git'], 'fastnoise', '' ],
    [ ['https://github.com/Relintai/mesh_data_resource.git', 'git@github.com:Relintai/mesh_data_resource.git'], 'mesh_data_resource', '' ],
    [ ['https://github.com/Relintai/procedural_animations.git', 'git@github.com:Relintai/procedural_animations.git'], 'procedural_animations', '' ],
    [ ['https://github.com/Relintai/props.git', 'git@github.com:Relintai/props.git'], 'props', '' ],
    [ ['https://github.com/Relintai/mesh_utils.git', 'git@github.com:Relintai/mesh_utils.git'], 'mesh_utils', '' ],
    [ ['https://github.com/Relintai/broken_seals_module.git', 'git@github.com:Relintai/broken_seals_module.git'], 'broken_seals_module', '' ],
    [ ['https://github.com/Relintai/thread_pool.git', 'git@github.com:Relintai/thread_pool.git'], 'thread_pool', '' ],
    [ ['https://github.com/Relintai/terraman.git', 'git@github.com:Relintai/terraman.git'], 'terraman', '' ],
]

removed_modules = [
    [ ['https://github.com/Relintai/voxelman.git', 'git@github.com:Relintai/voxelman.git'], 'voxelman', '' ],
]

addon_repositories = [
]

third_party_addon_repositories = [
]

target_commits = {}

godot_branch = '3.x'

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
    subprocess.call('git pull origin ' + branch, shell=True)
    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)

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

def remove_repository(data, target_folder):
    folder = os.path.abspath(target_folder + data[1])

    if os.path.isdir(folder):
        shutil.rmtree(folder)

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

    for rep in removed_modules:
        remove_repository(rep, './engine/modules/')


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

def format_path(path):
    if 'win' in sys.platform:
        path = path.replace('/', '\\')
        path = path.replace('~', '%userprofile%')

    return path

def get_exports_for(platform):
    export_command = 'export '
    command_separator = ';'

    if 'win' in sys.platform:
        command_separator = '&'
        export_command = 'set '

    command = ''

    for p in exports[platform]:
        command += export_command + p + command_separator

    return command


def parse_config():
    global visual_studio_vcvarsall_path
    global visual_studio_arch
    global visual_studio_call_vcvarsall
    global exports

    if not os.path.isfile('build.config'):
        return

    with open('build.config', 'r') as f:

        for line in f:
            ls = line.strip()
            if ls == '' or ls.startswith('#'):
                continue

            words = line.split()

            if (len(words) < 2):
                print('This build.config line is malformed, and got ignored: ' + ls)
                continue

            if words[0] == 'visual_studio_vcvarsall_path':
                visual_studio_vcvarsall_path = format_path(ls[29:])
            elif words[0] == 'visual_studio_arch':
                visual_studio_arch = format_path(ls[19:])
            elif words[0] == 'visual_studio_call_vcvarsall':
                visual_studio_call_vcvarsall = words[1].lower() in [ 'true', '1', 't', 'y', 'yes' ]
            elif words[0] == 'export':
                if (len(words) < 3) or not words[1] in exports:
                    print('This build.config line is malformed, and got ignored: ' + ls)
                    continue

                export_path = format_path(ls[8 + len(words[1]):])

                exports[words[1]].append(export_path)

parse_config()

env = Environment()

if len(sys.argv) > 1:

    arg = sys.argv[1]

    arg_split = arg.split('_')
    arg = arg_split[0]
    arg_split = arg_split[1:]

    if arg[0] == 'b':
        build_string = get_exports_for('global') + 'scons '

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
            if 'win' in sys.platform and visual_studio_call_vcvarsall:
                build_string = 'call "{0}" {1}&'.format(visual_studio_vcvarsall_path, visual_studio_arch) + build_string

        if 'o' in arg:
            build_string += 'use_llvm=yes'

        if 'v' in arg:
            build_string += 'vsproj=yes'

        for i in range(2, len(sys.argv)):
            build_string += ' ' + sys.argv[i] + ' '

        if 'slim' in arg_split:
            build_string += 'module_webm_enabled=no module_arkit_enabled=no module_visual_script_enabled=no module_gdnative_enabled=no module_mobile_vr_enabled=no module_theora_enabled=no module_xatlas_unwrap_enabled=no'
            build_string += ' '

        if 'latomic' in arg_split:
            build_string += 'LINKFLAGS="-latomic"'
            build_string += ' '

        if 'strip' in arg_split:
            build_string += 'debug_symbols=no'
            build_string += ' '

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

        cwd = os.getcwd()
        full_path = cwd + '/engine/'

        if not os.path.isdir(full_path):
            print('engine directory doesnt exists.')
            exit()

        os.chdir(full_path)

        if 'l' in arg:
            build_string += 'platform=x11'

            build_string = get_exports_for('linux') + build_string + target

            print('Running command: ' + build_string)

            subprocess.call(build_string, shell=True)
        elif 'w' in arg:
            build_string += 'platform=windows'

            build_string = get_exports_for('windows') + build_string

            print('Running command: ' + build_string)

            subprocess.call(build_string, shell=True)
        elif 'a' in arg:
            build_string += 'platform=android'

            build_string = get_exports_for('android') + build_string

            print('Running command: ' + build_string + ' android_arch=armv7')
            subprocess.call(build_string + ' android_arch=armv7', shell=True)
            print('Running command: ' + build_string + ' android_arch=arm64v8')
            subprocess.call(build_string + ' android_arch=arm64v8', shell=True)
            print('Running command: ' + build_string + ' android_arch=x86')
            subprocess.call(build_string + ' android_arch=x86', shell=True)

            os.chdir(full_path + 'platform/android/java/')

            print('Running command: ' + get_exports_for('global') + get_exports_for('android') + './gradlew generateGodotTemplates')
            subprocess.call(get_exports_for('global') + get_exports_for('android') + './gradlew generateGodotTemplates', shell=True)
        elif 'j' in arg:
            build_string += 'platform=javascript'

            build_string = get_exports_for('javascript') + build_string

            print('Running command: ' + build_string)
            subprocess.call(build_string, shell=True)
        elif 'i' in arg:
            build_string += 'platform=iphone'

            subprocess.call(build_string + ' arch=arm', shell=True)
            subprocess.call(build_string + ' arch=arm64', shell=True)

            #subprocess.call('lipo -create bin/libgodot.iphone.{0}.arm.a bin/libgodot.iphone.{0}.arm64.a -output bin/libgodot.iphone.{1}.fat.a'.fomat(), shell=True)

            #lipo -create bin/libgodot.iphone.opt.debug.arm.a bin/libgodot.iphone.opt.debug.arm64.a -output bin/libgodot.iphone.debug.fat.a
            #rm bin/ios_xcode/libgodot.iphone.debug.fat.a
            #cp bin/libgodot.iphone.debug.fat.a  bin/ios_xcode/libgodot.iphone.debug.fat.a

            #lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a -output bin/libgodot.iphone.release.fat.a
            #rm bin/ios_xcode/libgodot.iphone.release.fat.a
            #cp bin/libgodot.iphone.release.fat.a  bin/ios_xcode/libgodot.iphone.release.fat.a

            subprocess.call('rm bin/iphone.zip', shell=True)
            #cd bin/ios_xcode
            subprocess.call(build_string + ' arch=arm64', shell=True)
            subprocess.call('zip -r -X ../iphone.zip .', shell=True)

        else:
            print('No platform specified')
            exit()

        exit()
    elif arg[0] == 'p':
        if arg == 'p':
            print("Applies a patch. No Patches right now.Append s for the skeleton editor patch. For example: ps ")
            exit()

        cwd = os.getcwd()
        full_path = cwd + '/engine/'

        if not os.path.isdir(full_path):
            print('engine directory does not exists.')
            exit()

        os.chdir(full_path)

        #apply the patch to just the working directory, without creating a commit

        if 's' in arg:
            subprocess.call('git apply --index ../patches/custom_skeleton_3d_editor_plugin.patch', shell=True)

            #unstage all files
            subprocess.call('git reset', shell=True)

            vman_full_path = cwd + '/engine/modules/voxelman/'

            #also patch voxelman as the plugin changes forward_spatial_gui_input's definition
            if os.path.isdir(vman_full_path):
                os.chdir(vman_full_path)

                subprocess.call('git apply --index ../../../patches/fix-voxel-editor-after-the-skeleton-editor-patch.patch', shell=True)

                #unstage all files
                subprocess.call('git reset', shell=True)
            else:
                print('Voxelman directory does not exists, skipping patch.')



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
        
