extends Label

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _ready():
	Settings.connect("setting_changed", self, "setting_changed")
	
	if visible:
		set_process(true)
	else:
		set_process(false)
		
func _exit_tree():
	if Settings != null:
		Settings.disconnect("setting_changed", self, "setting_changed")
		
func setting_changed(section, key, value):
	if section == "debug" and key == "debug_info":
		if value:
			show()
			set_process(true)
		else:
			hide()
			set_process(false)

func _process(delta):
	var a : String = "Fps: " + str(Performance.get_monitor(Performance.TIME_FPS)) + "\n"
#	a += "time_process: " + str(Performance.get_monitor(Performance.TIME_PROCESS))  + "\n"
#	a += "time_physics_process: " + str(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS))  + "\n"
	a += "mem_static: " + str(Performance.get_monitor(Performance.MEMORY_STATIC))  + "\n"
	a += "mem_dynamic: " + str(Performance.get_monitor(Performance.MEMORY_DYNAMIC))  + "\n"
#	a += "mem_static_max: " + str(Performance.get_monitor(Performance.MEMORY_STATIC_MAX))  + "\n"
#	a += "mem_dyn_max: " + str(Performance.get_monitor(Performance.MEMORY_DYNAMIC_MAX))  + "\n"
#	a += "mem_msg_buf_max: " + str(Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX))  + "\n"
	a += "obj_count: " + str(Performance.get_monitor(Performance.OBJECT_COUNT))  + "\n"
	a += "obj_res_count: " + str(Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT))  + "\n"
	a += "obj_mode_count: " + str(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))  + "\n"
	a += "obj_orphan_mode_count: " + str(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))  + "\n"
	a += "obj_in_frame: " + str(Performance.get_monitor(Performance.RENDER_OBJECTS_IN_FRAME))  + "\n"
	a += "vert_in_frame: " + str(Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME))  + "\n"
	a += "mat_changes: " + str(Performance.get_monitor(Performance.RENDER_MATERIAL_CHANGES_IN_FRAME))  + "\n"
	a += "shader_changes: " + str(Performance.get_monitor(Performance.RENDER_SHADER_CHANGES_IN_FRAME))  + "\n"
	a += "surface_changes: " + str(Performance.get_monitor(Performance.RENDER_SURFACE_CHANGES_IN_FRAME))  + "\n"
	a += "draw_calls: " + str(Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME))  + "\n"
	a += "vid_mem_used: " + str(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))  + "\n"
#	a += "texture_mem_used: " + str(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))  + "\n"
#	a += "vertex_mem_used: " + str(Performance.get_monitor(Performance.RENDER_VERTEX_MEM_USED))  + "\n"
#	a += "vid_mem_total: " + str(Performance.get_monitor(Performance.RENDER_USAGE_VIDEO_MEM_TOTAL))  + "\n"
	
#	a += "phys_2d_active_obj: " + str(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS))  + "\n"
#	a += "phys_2d_coll_pairs: " + str(Performance.get_monitor(Performance.PHYSICS_2D_COLLISION_PAIRS))  + "\n"
#	a += "phys_2d_island_count: " + str(Performance.get_monitor(Performance.PHYSICS_2D_ISLAND_COUNT))  + "\n"
#	a += "phys_3d_active_obj: " + str(Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS))  + "\n"
#	a += "phys_3d_coll_pairs: " + str(Performance.get_monitor(Performance.PHYSICS_3D_COLLISION_PAIRS))  + "\n"
#	a += "phys_3d_island_count: " + str(Performance.get_monitor(Performance.PHYSICS_3D_ISLAND_COUNT))  + "\n"
#	a += "audio_output_latency: " + str(Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY))  + "\n"
	
	text = a

