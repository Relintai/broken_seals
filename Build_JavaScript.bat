rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

cd ./engine

call scons -j2 platform=javascript tools=no target=release_debug entities_2d=no

cd ..
