tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name SubZone

export(Array) var subzone_props : Array

func get_content() -> Array:
	return subzone_props

func set_content(arr : Array) -> void:
	subzone_props = arr

func create_content(item_name : String = "") -> void:
	var subzone_prop : SubZoneProp = SubZoneProp.new()
	subzone_prop.resource_name = item_name
	
	var r : Rect2 = get_rect()
	r.position = Vector2()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	subzone_prop.set_rect(r)
	
	add_content(subzone_prop)

func add_content(entry : WorldGenBaseResource) -> void:
	subzone_props.append(entry)
	emit_changed()
	
func remove_content_entry(entry : WorldGenBaseResource) -> void:
	for i in range(subzone_props.size()):
		if subzone_props[i] == entry:
			subzone_props.remove(i)
			emit_changed()
			return

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
