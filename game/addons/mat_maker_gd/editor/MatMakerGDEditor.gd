tool
extends MarginContainer

var MMGraphNode = preload("res://addons/mat_maker_gd/editor/mm_graph_node.gd")

export(PoolColorArray) var slot_colors : PoolColorArray

export(NodePath) var graph_edit_path : NodePath = "VBoxContainer/GraphEdit"
export(NodePath) var add_popup_path : NodePath = "Popups/AddPopup"

var _graph_edit : GraphEdit = null

var _material : MMMateial
var _ignore_material_change_event : int = 0
var _recreation_in_progress : bool = false

var _plugin : EditorPlugin = null
var _undo_redo : UndoRedo = null

func _enter_tree():
	ensure_objs()

func set_plugin(plugin : EditorPlugin) -> void:
	_plugin = plugin
	_undo_redo = plugin.get_undo_redo()

func get_undo_redo() -> UndoRedo:
	return _undo_redo

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
	ignore_changes(true)
	
	if _recreation_in_progress:
		return

	_recreation_in_progress = true
	
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
		gn.set_editor(self)
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
	
	_recreation_in_progress = false
	
	ignore_changes(false)

func find_graph_node_for(nnode) -> Node:
	for c in _graph_edit.get_children():
		if c is GraphNode:
			if c.has_method("get_material_node"):
				var n = c.get_material_node()
				
				if n == nnode:
					return c

	return null

func set_mmmaterial(object : MMMateial):
	if _material:
		_material.disconnect("changed", self, "on_material_changed")
	
	_material = object

	recreate()
		
	if _material:
		_material.connect("changed", self, "on_material_changed")

func on_material_changed() -> void:
	if _ignore_material_change_event > 0:
		return
	
	if _recreation_in_progress:
		return
		
	call_deferred("recreate")

func ignore_changes(val : bool) -> void:
	if val:
		_ignore_material_change_event += 1
	else:
		_ignore_material_change_event -= 1

func on_graph_edit_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	var from_node : GraphNode = _graph_edit.get_node(from)
	var to_node : GraphNode = _graph_edit.get_node(to)
	
	ignore_changes(true)
	
	_material.cancel_render_and_wait()
	
	if from_node.connect_slot(from_slot, to_node, to_slot):
		_graph_edit.connect_node(from, from_slot, to, to_slot)
		
	ignore_changes(false)

func on_graph_edit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int):
	var from_node : GraphNode = _graph_edit.get_node(from)
	var to_node : GraphNode = _graph_edit.get_node(to)
	
	ignore_changes(true)
	
	_material.cancel_render_and_wait()

	if from_node.disconnect_slot(from_slot, to_node, to_slot):
		_graph_edit.disconnect_node(from, from_slot, to, to_slot)
		
	ignore_changes(false)

func on_graph_node_close_request(node : GraphNode) -> void:
	if _material:
		ignore_changes(true)
		
		_material.cancel_render_and_wait()
		
		#_material.remove_node(node._node)
		
		_undo_redo.create_action("MMGD: Remove Node")
		_undo_redo.add_do_method(_material, "remove_node", node._node)
		_undo_redo.add_undo_method(_material, "add_node", node._node)
		_undo_redo.commit_action()
		
		recreate()
		
		ignore_changes(false)

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
	
	ignore_changes(true)
	
	#_material.add_node(nnode)
	
	_undo_redo.create_action("MMGD: Add Node")
	_undo_redo.add_do_method(_material, "add_node", nnode)
	_undo_redo.add_undo_method(_material, "remove_node", nnode)
	_undo_redo.commit_action()
	
	var gn : GraphNode = MMGraphNode.new()
	gn.slot_colors = slot_colors
	gn.set_editor(self)
	gn.set_node(_material, nnode)
	_graph_edit.add_child(gn)
	
	ignore_changes(false)
	
