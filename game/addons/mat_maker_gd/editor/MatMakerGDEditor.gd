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
		
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_INT, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR3, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)

		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_INT)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR3)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR)
		
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL)
		
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_INT, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_INT)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR3, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR3)
		_graph_edit.add_valid_connection_type(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR)

		_graph_edit.connect("connection_request", self, "on_graph_edit_connection_request")
		_graph_edit.connect("disconnection_request", self, "on_graph_edit_disconnection_request")

func recreate() -> void:
	ensure_objs()
	
	_graph_edit.clear_connections()
	
	for c in _graph_edit.get_children():
		if c is GraphNode:
			_graph_edit.remove_child(c)
			c.queue_free()
		
	if !_material:
		return
		
	_material.cancel_render_and_wait()
		
	for n in _material.nodes:
		var gn : GraphNode = MMGraphNode.new()
		gn.slot_colors = slot_colors
		gn.set_node(_material, n)
		_graph_edit.add_child(gn)
		
	#connect them
	for n in _material.nodes:
		if n:
			for ip in n.input_properties:
				if ip.input_property:
					var input_node : Node = find_graph_node_for(n)
					var output_node : Node = find_graph_node_for(ip.input_property.owner)
					
					var to_slot : int = input_node.get_input_property_graph_node_slot_index(ip)
					var from_slot : int = output_node.get_output_property_graph_node_slot_index(ip.input_property)
					
					_graph_edit.connect_node(output_node.name, from_slot, input_node.name, to_slot)
	
	_material.render()

func find_graph_node_for(nnode) -> Node:
	for c in _graph_edit.get_children():
		if c is GraphNode:
			if c.has_method("get_material_node"):
				var n = c.get_material_node()
				
				if n == nnode:
					return c

	return null

func set_mmmaterial(object : MMMateial):
	_material = object
	
	recreate()
	
func on_graph_edit_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	var from_node : GraphNode = _graph_edit.get_node(from)
	var to_node : GraphNode = _graph_edit.get_node(to)
	
	_material.cancel_render_and_wait()

	if from_node.connect_slot(from_slot, to_node, to_slot):
		_graph_edit.connect_node(from, from_slot, to, to_slot)

func on_graph_edit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int):
	var from_node : GraphNode = _graph_edit.get_node(from)
	var to_node : GraphNode = _graph_edit.get_node(to)
	
	_material.cancel_render_and_wait()

	if from_node.disconnect_slot(from_slot, to_node, to_slot):
		_graph_edit.disconnect_node(from, from_slot, to, to_slot)

func on_graph_node_close_request(node : GraphNode) -> void:
	if _material:
		_material.cancel_render_and_wait()
		_material.remove_node(node._node)
		recreate()

func _on_AddButton_pressed():
	get_node(add_popup_path).popup_centered()

func _on_AddPopup_ok_pressed(script_path : String):
	if !_material:
		return
	
	ensure_objs()
	
	_material.cancel_render_and_wait()

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
	
