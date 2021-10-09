tool
extends MarginContainer

var MMGraphNode = preload("res://addons/mat_maker_gd/editor/mm_graph_node.gd")

export(PoolColorArray) var slot_colors : PoolColorArray

export(NodePath) var graph_edit_path : NodePath = "VBoxContainer/GraphEdit"
export(NodePath) var add_popup_path : NodePath = "Popups/AddPopup"

var _graph_edit : GraphEdit = null

var _material : MMMateial

func _enter_tree():
	ensure_objs()

func ensure_objs() -> void:
	if !_graph_edit:
		_graph_edit = get_node(graph_edit_path)

func recreate() -> void:
	ensure_objs()
	
	for c in _graph_edit.get_children():
		if c is GraphNode:
			_graph_edit.remove_child(c)
			c.queue_free()
		
	if !_material:
		return
		
	for n in _material.nodes:
		var gn : GraphNode = MMGraphNode.new()
		gn.slot_colors = slot_colors
		gn.set_node(_material, n)
		_graph_edit.add_child(gn)
		
	#connect them
	
	_material.render()

func set_mmmaterial(object : MMMateial):
	_material = object
	
	recreate()

func _on_AddButton_pressed():
	get_node(add_popup_path).popup_centered()

func _on_AddPopup_ok_pressed(script_path : String):
	if !_material:
		return
	
	ensure_objs()

	var sc = load(script_path)
	var nnode : MMNode = sc.new()
	
	if !nnode:
		print("_on_AddPopup_ok_pressed: Error !nnode! script: " + script_path)
		return
	
	_material.add_node(nnode)
	
	var gn : GraphNode = MMGraphNode.new()
	gn.slot_colors = slot_colors
	gn.set_node(_material, nnode)
	_graph_edit.add_child(gn)
	
