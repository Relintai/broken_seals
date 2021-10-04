tool
class_name MMMateial
extends Resource

var MMMNode = preload("res://addons/mat_maker_gd/nodes/mm_node.gd")

export(Vector2) var image_size : Vector2 = Vector2(128, 128)
export(Array) var nodes : Array

func add_node(node : MMNode) -> void:
	nodes.append(node)
	emit_changed()
