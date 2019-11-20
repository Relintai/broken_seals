extends Node

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
