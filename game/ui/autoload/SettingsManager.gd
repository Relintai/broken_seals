extends Node

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

signal setting_changed(section, key, value)
signal settings_loaded()

const SAVE_PATH : String = "user://settings.cfg"

var loaded : bool = false

var _config_file : ConfigFile = ConfigFile.new()
var _settings : Dictionary = {
	"rendering" : {
		"window_size" : OS.window_size,
		"window_position" : OS.window_position,

		"viewport_scale" : ProjectSettings.get("display/window/size/viewport_scale"),
		"thread_model" : ProjectSettings.get("rendering/threads/thread_model"),
		"borderless" : ProjectSettings.get("display/window/size/borderless"),
		"fullscreen" : ProjectSettings.get("display/window/size/fullscreen"),
		"always_on_top" : ProjectSettings.get("display/window/size/always_on_top"),
		"shadows_enabled" : ProjectSettings.get("rendering/quality/shadows/enabled"),
		"use_vsync" : ProjectSettings.get("display/window/vsync/use_vsync"),
		"vsync_via_compositor" : ProjectSettings.get("display/window/vsync/vsync_via_compositor"),
	},
	"ui" : {
		"touchscreen_mode" : OS.has_touchscreen_ui_hint(),
		"ui_scale" : ProjectSettings.get("display/window/size/ui_scale"),
		"ui_scale_touch" : ProjectSettings.get("display/window/size/ui_scale_touch"),
	},
	"debug" : {
		"debug_info" : false
	}
}

func _ready():
	load_settings()
	
	var actions : Array = InputMap.get_actions()
	
	for action in actions:
		var acts : Array = InputMap.get_action_list(action)
		
		for i in range(len(acts)):
			var a = acts[i]
			if a is InputEventKey:
				var nie : BSInputEventKey = BSInputEventKey.new()
				nie.from_input_event_key(a as InputEventKey)
				acts[i] = nie
				
				InputMap.action_erase_event(action, a)
				InputMap.action_add_event(action, nie)
				
	set_stretch()
	setup_window()

func _exit_tree():
	if OS.window_fullscreen:
		return
	
	var wp : Vector2 = OS.window_position
	var ws : Vector2 = OS.window_size
	
	var wpr = get_value("rendering", "window_position")
	var wsr = get_value("rendering", "window_size")
	
	if int(wp.x) != int(wpr.x) || \
		int(wp.y) != int(wpr.y) || \
		int(ws.x) != int(wsr.x) || \
		int(ws.y) != int(wsr.y):
			
		#don't use set_value() here, as the app is quitting
		_settings["rendering"]["window_size"] = ws
		_settings["rendering"]["window_position"] = wp
		
		save_settings()

func set_value(section, key, value) -> void:
	_settings[section][key] = value
	
	if has_method("set_" + section + "_" + key):
		call("set_" + section + "_" + key, value)
		
	save_settings()

	emit_signal("setting_changed", section, key, value)
	
func get_value(section, key):
	return _settings[section][key]
		
func _set_value(section, key, value) -> void:
	_settings[section][key] = value
	
	if has_method("set_" + section + "_" + key):
		call("set_" + section + "_" + key, value)

func save_settings() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
			
	_config_file.save(SAVE_PATH)

func load_settings() -> void:
	var error : int = _config_file.load(SAVE_PATH)
	
	if error != OK:
#		print("Failed to load the settings file! Error code %s" % error)
		return
	
	for section in _settings.keys():
		for key in _settings[section]:
			_set_value(section, key, _config_file.get_value(section, key, _settings[section][key]))
			
	loaded = true
	emit_signal("settings_loaded")

func set_rendering_thread_model(value : int) -> void:
	ProjectSettings.set("rendering/threads/thread_model", value)
	
func set_rendering_borderless(value : bool) -> void:
	ProjectSettings.set("display/window/size/borderless", value)
	OS.window_borderless = value
	
func set_rendering_fullscreen(value : bool) -> void:
	ProjectSettings.set("display/window/size/fullscreen", value)
	OS.window_fullscreen = value
	
	if !value:
		setup_window()
	
func set_rendering_always_on_top(value : bool) -> void:
	ProjectSettings.set("display/window/size/always_on_top", value)
	OS.set_window_always_on_top(value)
	
func set_rendering_viewport_scale(value : int) -> void:
	ProjectSettings.set("rendering/window/size/viewport_scale", value)
	var v: Vector2 = OS.get_window_size()
	v *= value * 0.01
	
	get_tree().get_root().size = v

func set_rendering_shadows_enabled(value : bool) -> void:
	ProjectSettings.set("rendering/quality/shadows/enabled", value)

func set_rendering_use_vsync(value : bool) -> void:
	ProjectSettings.set("display/window/vsync/use_vsync", value)
	
	OS.vsync_enabled = value
	
func set_rendering_vsync_via_compositor(value : bool) -> void:
	ProjectSettings.set("display/window/vsync/vsync_via_compositor", value)
	
	OS.vsync_via_compositor = value

func set_ui_touchscreen_mode(value : bool) -> void:
	set_stretch()

func set_ui_ui_scale(value : float) -> void:
	ProjectSettings.set("rendering/window/size/ui_scale", value)
	set_stretch()
	
func set_ui_ui_scale_touch(value : float) -> void:
	ProjectSettings.set("rendering/window/size/ui_scale_touch", value)
	set_stretch()

func set_stretch():
	if !loaded:
		return
		
	var stretch_mode : String = ProjectSettings.get("display/window/stretch/mode")
	var stretch_aspect : String = ProjectSettings.get("display/window/stretch/aspect")
	var stretch_size : Vector2 = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	var stretch_shrink : float = ProjectSettings.get("display/window/stretch/shrink")
	
	var uiscale : float = 1
	
	if !get_value("ui", "touchscreen_mode"):
		uiscale = get_value("ui", "ui_scale")
	else:
		uiscale = get_value("ui", "ui_scale_touch")
		
	stretch_size *= uiscale
	
	var sml_sm = SceneTree.STRETCH_MODE_DISABLED;
	if (stretch_mode == "2d"):
		sml_sm = SceneTree.STRETCH_MODE_2D;
	elif (stretch_mode == "viewport"):
		sml_sm = SceneTree.STRETCH_MODE_VIEWPORT;

	var sml_aspect = SceneTree.STRETCH_ASPECT_IGNORE;
	if (stretch_aspect == "keep"):
		sml_aspect = SceneTree.STRETCH_ASPECT_KEEP;
	elif (stretch_aspect == "keep_width"):
		sml_aspect = SceneTree.STRETCH_ASPECT_KEEP_WIDTH;
	elif (stretch_aspect == "keep_height"):
		sml_aspect = SceneTree.STRETCH_ASPECT_KEEP_HEIGHT;
	elif (stretch_aspect == "expand"):
		sml_aspect = SceneTree.STRETCH_ASPECT_EXPAND;
	
	get_tree().set_screen_stretch(sml_sm, sml_aspect, stretch_size, stretch_shrink)

func setup_window():
	if OS.window_fullscreen:
		return
	
	OS.window_position = get_value("rendering", "window_position")
	OS.window_size = get_value("rendering", "window_size")
