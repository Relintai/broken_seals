# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd engine
scons -j2 platform=x11 target=release_debug entities_2d=no tools=no

# use_llvm=yes


