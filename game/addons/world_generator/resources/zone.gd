tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name Zone

export(Array) var subzones : Array

func get_content() -> Array:
	return subzones

func set_content(arr : Array) -> void:
	subzones = arr

func add_content(item_name : String = "") -> void:
	var subzone : SubZone = SubZone.new()
	subzone.resource_name = item_name
	
	var r : Rect2 = get_rect()
	r.position = Vector2()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	subzone.set_rect(r)
	
	subzones.append(subzone)
	emit_changed()

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
