tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name WorldGenWorld

export(Array) var continents : Array

func get_content() -> Array:
	return continents

func set_content(arr : Array) -> void:
	continents = arr

func create_content(item_name : String = "") -> void:
	var continent : Continent = Continent.new()
	continent.resource_name = item_name

	add_content(continent)

func add_content(entry : WorldGenBaseResource) -> void:
	var r : Rect2 = get_rect()
	r.position = Vector2()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	entry.set_rect(r)
	
	continents.append(entry)
	entry.set_parent_pos(get_parent_pos() + get_rect().position)
	emit_changed()

func remove_content_entry(entry : WorldGenBaseResource) -> void:
	for i in range(continents.size()):
		if continents[i] == entry:
			continents.remove(i)
			emit_changed()
			return

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
