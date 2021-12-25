tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name WorldGenWorld

export(Array) var continents : Array

func get_content() -> Array:
	return continents

func set_content(arr : Array) -> void:
	continents = arr

func add_content() -> void:
	var continent : Continent = Continent.new()
	
	var r : Rect2 = get_rect()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	continent.set_rect(r)
	
	continents.append(continent)
	emit_changed()

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
