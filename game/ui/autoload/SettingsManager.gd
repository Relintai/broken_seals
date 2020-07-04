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
	
