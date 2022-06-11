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

import os
import subprocess
import json
import sys

import module_config

repository_index = 0
clone_command = 'git clone {0} {1}'
target_commits = {}

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

    target = ""

    if data[1] in target_commits:
        target = target_commits[data[1]][branch]

    subprocess.call('git checkout -B ' + branch + ' ' + target, shell=True)
    subprocess.call('git clean -f -d', shell=True)
    subprocess.call('git reset', shell=True)
    subprocess.call('git reset --hard', shell=True)

    os.chdir(cwd)


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

def update_engine():
    validate_repository_origin(module_config.engine_repository, './pandemonium_engine/', module_config.pandemonium_branch)
    update_repository(module_config.engine_repository, '/', module_config.pandemonium_branch)

engine_abspath = os.path.abspath(module_config.engine_repository[1])

if not os.path.isdir(engine_abspath):
    if not os.path.isfile('./HEADS'):
        print("Error! HEADS file doesn't exists! Exiting.")
        exit()

    with open('./HEADS', 'r') as infile:
        target_commits = json.load(infile)

    if 'repository_type=ssh' in sys.argv:
        repository_index = 1

    setup_repository(module_config.engine_repository, '/', module_config.pandemonium_branch)
else:
    if not os.path.isfile('pandemonium_engine/misc/scripts_app/SConstruct'):
        update_engine()


SConscript("pandemonium_engine/misc/scripts_app/SConstruct")


