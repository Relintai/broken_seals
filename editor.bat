rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

copy "engine\bin\godot.windows.opt.tools.64.exe" "engine\bin\run_godot.windows.opt.tools.64.exe" /y
copy "engine\bin\godot.windows.opt.tools.64.pdb" "engine\bin\run_godot.windows.opt.tools.64.pdb" /y
copy "engine\bin\godot.windows.opt.tools.64.exp" "engine\bin\run_godot.windows.opt.tools.64.exp" /y

cmd /c engine\bin\run_godot.windows.opt.tools.64.exe 