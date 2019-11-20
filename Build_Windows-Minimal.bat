rem This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

rem call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

cd ./engine

rem scons -j6 platform=windows

if not defined DevEnvDir (
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
)

call scons -j6 platform=windows target=release_debug entities_2d=no  javascript_eval=false module_arkit_enabled=no module_assimp_enabled=no module_csg_enabled=no module_gdnative_enabled=no module_opus_enabled=no module_webp_enabled=no module_webm_enabled=no module_visual_script_enabled=no module_xatlas_unwrap_enabled=no module_theora_enabled=no module_vhacd_enabled=no module_tinyexr_enabled=no module_squish_enabled=no module_gridmap_enabled=no
 
cd ..

rem use_lto=yes 
rem module_regex_enabled=no

rem javascript_eval=false


rem module_hdr_enabled=no
rem module_jpg_enabled=no
rem module_jsonrpc_enabled=no
rem module_pvr_enabled=no







rem module_cvtt_enabled?
rem  module_dds_enabled?
