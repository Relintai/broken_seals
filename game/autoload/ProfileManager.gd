extends ProfileManager

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#export (float) var save_interval : float = 20
#var last_save_time : float = 0

func _ready():
	var save_game : File = File.new()

	if save_game.file_exists("user://profile.save"):
		load_full()
	else:
		load_defaults()
		
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
				

func _save() -> void:
	save_full()
	
func _load() -> void:
	load_full()

func save_full() -> void:
	var save_game = File.new()
	
	save_game.open("user://profile.save", File.WRITE)
	
	save_game.store_line(to_json(to_dict()))
	
	save_game.close()
	
func load_full() -> void:
	clear_class_profiles()

	var save_game : File = File.new()
	
	if save_game.file_exists("user://profile.save"):
		if save_game.open("user://profile.save", File.READ) == OK:
		
			var text : String = save_game.get_as_text()
			
			if text == "":
				load_defaults()
				return
			
			var save_json : Dictionary = parse_json(text)
	
			from_dict(save_json)

