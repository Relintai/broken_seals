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

import sys
import os
import subprocess
import json
import shutil
import traceback

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

def copytree(src, dst, warn = 0):
    for item in os.listdir(src):
    
        sp = os.path.join(src, item)
        dp = os.path.join(dst, item)

        if os.path.isdir(sp):
            if item == ".git" or item == ".gradle" or item == "bin" or item == "__pycache__" or item == ".import" or item == "logs" or item == "release" or item == "export" or item == "build" or item == "libs":
                continue

            #print(item)

            if os.path.isdir(dp):
                shutil.rmtree(dp, onerror=onerror)

            copytree(sp, dp, warn)
        else:
            if item.endswith(".a") or item.endswith(".class") or item.endswith(".dex") or item.endswith(".pyc") or item.endswith(".o") or item.endswith(".bc") or item.endswith(".so") or item == "export_presets.cfg" or item.endswith(".gen.h") or item.endswith(".os") or item.endswith(".dblite") or item == ".scons_node_count" or item == ".scons_env.json" or item == "compile_commands.json" or item == "config.log" or item.endswith(".gen.inc") or item.endswith(".gen.cpp") :
                continue

            #print(item)

            if not os.path.isdir(dst):
                os.makedirs(dst)

            file_size_bytes = os.path.getsize(sp)

            if warn > 0 and file_size_bytes >= warn:
                # Ignore assets, this is meant to catch temp / generated files
                if not (item.endswith(".po") or item.endswith(".tres") or item.endswith(".ttf") or item.endswith(".tza") or item.endswith(".blend") or item.endswith(".blend1") or item.endswith(".pot")):
                    print("WARNING! File '", sp, "' (", file_size_bytes, "bytes) is over the warn threshold!")

            shutil.copy2(sp, dp)

def copy_repository(data, target_folder, clone_path):
    copytree(os.path.abspath(clone_path + data[1] + '/' + data[2]), os.path.abspath(target_folder + data[1]))


#copy_repository(rep, './game/addons/', '.' + module_clone_path)

#print(sys.argv)

if len(sys.argv) == 3 or len(sys.argv) == 4:
    src_dir = sys.argv[1]
    dst_dir = sys.argv[2]
    warn = 0

    if len(sys.argv) == 4:
        warn = int(sys.argv[3])

    src_dir = os.path.abspath(src_dir)
    dst_dir = os.path.abspath(dst_dir)

    copytree(src_dir, dst_dir, warn)


else:
    print("Usange: python copy_repos.py source_dir target_dir")
