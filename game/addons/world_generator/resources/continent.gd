tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name Continent

export(Array) var zones : Array

func get_content() -> Array:
	return zones

func set_content(arr : Array) -> void:
	zones = arr

func create_content(item_name : String = "") -> void:
	var zone : Zone = Zone.new()
	zone.resource_name = item_name
	
	var r : Rect2 = get_rect()
	r.position = Vector2()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	zone.set_rect(r)
	
	add_content(zone)

func add_content(entry : WorldGenBaseResource) -> void:
	zones.append(entry)
	emit_changed()

func remove_content_entry(entry : WorldGenBaseResource) -> void:
	for i in range(zones.size()):
		if zones[i] == entry:
			zones.remove(i)
			emit_changed()
			return

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
