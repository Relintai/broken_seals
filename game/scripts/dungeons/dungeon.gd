tool
extends Spatial

export(bool) var generate_on_ready : bool = true
export(PropData) var start_room : PropData
export(Array, PropData) var rooms : Array
export(bool) var generate : bool setget set_generate, get_generate

var portal_map : Dictionary

var debug : bool = true

func _enter_tree():
	if not Engine.editor_hint && generate_on_ready:
		call_deferred("generate")

func set_up_room_data():
	clear_room_data()

func clear_room_data():
	portal_map.clear()

func generate():
	clear()
	set_up_room_data()
	

func clear():
	if not debug:
		for c in get_children():
			if c.owner == self:
				#don't destroy the user's nodes
				continue
				
			c.queue_delete()
	else:
		for c in get_children():
			c.queue_delete()

func set_generate(on):
	if on:
		generate()

func get_generate():
	return false
