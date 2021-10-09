tool
class_name MMMateial
extends Resource

export(Vector2) var image_size : Vector2 = Vector2(128, 128)
export(Array) var nodes : Array

var initialized : bool = false

func initialize():
	if !initialized:
		initialized = true
		
		for n in nodes:
			n.connect("changed", self, "on_node_changed")

func add_node(node : MMNode) -> void:
	nodes.append(node)
	
	node.connect("changed", self, "on_node_changed")
	
	emit_changed()
	
func remove_node(node : MMNode) -> void:
	nodes.erase(node)
	
	node.disconnect("changed", self, "on_node_changed")
	
	emit_changed()

func render() -> void:
	if !initialized:
		initialize()
		
	var did_render : bool = true
		
	while did_render:
		did_render = false
		
		for n in nodes:
			if n && n.render(self):
				did_render = true

func on_node_changed() -> void:
	call_deferred("render")
