extends Node

# Copyright (c) 2019 Péter Magyar
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

const SAVE_PATH : String = "user://settings.cfg"

var _config_file : ConfigFile = ConfigFile.new()
var _settings : Dictionary = {
	"rendering" : {
		"thread_model" : ProjectSettings.get("rendering/threads/thread_model")
	},
	"debug" : {
		"debug_info" : false
	}
}

func _ready():
	load_settings()
	
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
			

func set_rendering_thread_model(value : int) -> void:
	ProjectSettings.set("rendering/threads/thread_model", value)
