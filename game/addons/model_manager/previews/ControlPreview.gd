tool
extends ViewportContainer

export(NodePath) var container_path : NodePath

var _container : Node

func _ready() -> void:
	_container = get_node(container_path)

func preview(n: Control) -> void:
	_container.add_child(n)
	n.owner = _container
	
