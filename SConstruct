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

import module_config

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
    'osx': [],
    'ios': [],
    'server': [],
}

additional_commands = {
    'global': [],
    'linux': [],
    'windows': [],
    'android': [],
    'javascript': [],
    'osx': [],
    'ios': [],
    'server': [],
}

target_commits = {}

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

def validate_repository_origin(data, clone_path, branch = 'master'):
    full_path = os.path.abspath(clone_path)

    if not os.path.isdir(full_path):
        return

    cwd = os.getcwd()
    os.chdir(full_path)

    res = subprocess.run('git remote -v', shell=True, capture_output=True)

    resstr = res.stdout.decode('ascii')
    resarr = resstr.split("\n")
    res_orig = []

    for l in resarr:
        if "origin" in l:
            res_orig.append(l)

    if len(res_orig) == 0:
        print("The repository " + clone_path + " does not seem to have an origin remote. Adding it.")

        subprocess.call('git remote add origin ' + data[0][repository_index], shell=True)

        os.chdir(cwd)

        return

    for l in data[0]:
        for ll in res_orig:
            if l in ll:
                os.chdir(cwd)

                return

    rind = 0

    if 'git@' in res_orig[0]:
        rind = 1

    subprocess.call('git remote remove origin', shell=True)
    subprocess.call('git remote add origin ' + data[0][rind], shell=True)
    subprocess.call('git pull origin', shell=True)
    subprocess.call('git checkout origin/' + branch, shell=True)

    print('Updated git remote origin in ' + clone_path)

    os.chdir(cwd)

def remove_repository(data, target_folder):
    folder = os.path.abspath(target_folder + data[1])

    if os.path.isdir(folder):
        shutil.rmtree(folder)

def update_engine():
    validate_repository_origin(module_config.engine_repository, './pandemonium_engine/', module_config.pandemonium_branch)
    update_repository(module_config.engine_repository, '/', module_config.pandemonium_branch)

def update_modules():
    for rep in module_config.module_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './pandemonium_engine/modules/', '.' + module_clone_path)

def update_addons():
    for rep in module_config.addon_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def update_addons_third_party_addons():
    for rep in module_config.third_party_addon_repositories:
        update_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def update_all():
    update_engine()
    update_modules()
    update_addons()
    update_addons_third_party_addons()

    save_target_commits_array()


def setup_engine():
    validate_repository_origin(module_config.engine_repository, './pandemonium_engine/', module_config.pandemonium_branch)
    setup_repository(module_config.engine_repository, '/', module_config.pandemonium_branch)

def setup_modules():
    for rep in module_config.module_repositories:
        setup_repository(rep, module_clone_path)
        copy_repository(rep, './pandemonium_engine/modules/', '.' + module_clone_path)

    for rep in module_config.removed_modules:
        remove_repository(rep, './pandemonium_engine/modules/')


def setup_addons():
    for rep in module_config.addon_repositories:
        setup_repository(rep, module_clone_path)
        copy_repository(rep, './game/addons/', '.' + module_clone_path)

def setup_addons_third_party_addons():
    for rep in module_config.third_party_addon_repositories:
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

def get_additional_commands_for(platform):
    command_separator = ';'

    if 'win' in sys.platform:
        command_separator = '&'

    command = ''

    for p in additional_commands[platform]:
        command += p + command_separator

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
            elif words[0] == 'run':
                if (len(words) < 3) or not words[1] in additional_commands:
                    print('This build.config line is malformed, and got ignored: ' + ls)
                    continue

                final_cmd = format_path(ls[5 + len(words[1]):])

                additional_commands[words[1]].append(final_cmd)

parse_config()

env = Environment()

if len(sys.argv) > 1:

    arg = sys.argv[1]

    arg_split = arg.split('_')
    arg = arg_split[0]
    arg_split = arg_split[1:]

    if arg[0] == 'b':
        build_string = get_exports_for('global') + get_additional_commands_for('global') + 'scons '

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
            build_string += module_config.slim_args
            build_string += ' '

        if 'latomic' in arg_split:
            build_string += 'LINKFLAGS="-latomic"'
            build_string += ' '

        if 'strip' in arg_split:
            build_string += 'debug_symbols=no'
            build_string += ' '

        if 'threads' in arg_split:
            build_string += 'threads_enabled=yes'
            build_string += ' '

        if 'c' in arg:
            build_string += 'compiledb=yes'
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
        full_path = cwd + '/pandemonium_engine/'

        if not os.path.isdir(full_path):
            print('engine (pandemonium_engine) directory doesnt exists.')
            exit()

        os.chdir(full_path)

        if 'l' in arg:
            build_string += 'platform=x11'

            build_string = get_exports_for('linux') + get_additional_commands_for('linux') + build_string + target

            print('Running command: ' + build_string)

            subprocess.call(build_string, shell=True)
        elif 'w' in arg:
            build_string += 'platform=windows'

            build_string = get_exports_for('windows') + get_additional_commands_for('windows') + build_string

            print('Running command: ' + build_string)

            subprocess.call(build_string, shell=True)
        elif 'a' in arg:
            build_string += 'platform=android'

            build_string = get_exports_for('android') + get_additional_commands_for('android') + build_string

            print('Running command: ' + build_string + ' android_arch=armv7')
            subprocess.call(build_string + ' android_arch=armv7', shell=True)
            print('Running command: ' + build_string + ' android_arch=arm64v8')
            subprocess.call(build_string + ' android_arch=arm64v8', shell=True)
            print('Running command: ' + build_string + ' android_arch=x86')
            subprocess.call(build_string + ' android_arch=x86', shell=True)

            os.chdir(full_path + 'platform/android/java/')

            if 'e' in arg: #editor
                print('Running command: ' + get_exports_for('global') + get_additional_commands_for('global') + get_exports_for('android') + get_additional_commands_for('android') + './gradlew generatePandemoniumEditor')
                subprocess.call(get_exports_for('global') + get_additional_commands_for('global') + get_exports_for('android') + get_additional_commands_for('android') + './gradlew generatePandemoniumEditor', shell=True)
            else: #normal templates
                print('Running command: ' + get_exports_for('global') + get_additional_commands_for('global') + get_exports_for('android') + get_additional_commands_for('android') + './gradlew generatePandemoniumTemplates')
                subprocess.call(get_exports_for('global') + get_additional_commands_for('global') + get_exports_for('android') + get_additional_commands_for('android') + './gradlew generatePandemoniumTemplates', shell=True)
        elif 'j' in arg:
            build_string += 'platform=javascript'

            build_string = get_exports_for('javascript') + get_additional_commands_for('javascript') + build_string

            print('Running command: ' + build_string)
            subprocess.call(build_string, shell=True)
        elif 'i' in arg:
            build_string += 'platform=iphone'

            print('Running command: ' + build_string)
            subprocess.call(build_string, shell=True)

            #print('Running command: ' + build_string + " arch=arm")
            #subprocess.call(build_string + ' arch=arm', shell=True)
            #print('Running command: ' + build_string + " arch=arm64")
            #subprocess.call(build_string + ' arch=arm64', shell=True)
            #print('Running command: ' + build_string + " arch=x86_64")
            #subprocess.call(build_string + ' arch=x86_64', shell=True)
        elif 'x' in arg:
            build_string += 'platform=osx'

            build_string = get_exports_for('osx') + get_additional_commands_for('osx') + build_string + target

            print('Running command: ' + build_string)
            subprocess.call(build_string, shell=True)
        elif 'h' in arg:
            #headless
            build_string += 'platform=server'

            build_string = get_exports_for('server') + get_additional_commands_for('server') + build_string

            print('Running command: ' + build_string)

            subprocess.call(build_string, shell=True)

        else:
            print('No platform specified')
            exit()

        exit()
#    elif arg[0] == 'p':
#        if arg == 'p':
#            print("Applies a patch. No Patches right now.Append s for the skeleton editor patch. For example: ps ")
#            exit()
#
#        cwd = os.getcwd()
#        full_path = cwd + '/pandemonium_engine/'
#
#        if not os.path.isdir(full_path):
#            print('engine (pandemonium_engine) directory does not exists.')
#            exit()
#
#        os.chdir(full_path)
#
#        #apply the patch to just the working directory, without creating a commit
#
#        if 's' in arg:
#            subprocess.call('git apply --index ../patches/custom_skeleton_3d_editor_plugin.patch', shell=True)
#
#            #unstage all files
#            subprocess.call('git reset', shell=True)
#
#            vman_full_path = cwd + '/pandemonium_engine/modules/voxelman/'
#
#            #also patch voxelman as the plugin changes forward_spatial_gui_input's definition
#            if os.path.isdir(vman_full_path):
#                os.chdir(vman_full_path)
#
#                subprocess.call('git apply --index ../../../patches/fix-voxel-editor-after-the-skeleton-editor-patch.patch', shell=True)
#
#                #unstage all files
#                subprocess.call('git reset', shell=True)
#            else:
#                print('Voxelman directory does not exists, skipping patch.')
#
#        exit()

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
    pandemonium_branch = 'master'

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
        
