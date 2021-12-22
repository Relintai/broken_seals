tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name Zone

export(Array) var subzones : Array

func get_content() -> Array:
	return subzones

func set_content(arr : Array) -> void:
	subzones = arr

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
