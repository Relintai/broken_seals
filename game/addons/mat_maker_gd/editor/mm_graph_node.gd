tool
extends GraphNode

var gradient_editor_scene : PackedScene = preload("res://addons/mat_maker_gd/widgets/gradient_editor/gradient_editor.tscn")
var polygon_edit_scene : PackedScene = preload("res://addons/mat_maker_gd/widgets/polygon_edit/polygon_edit.tscn")
var curve_edit_scene : PackedScene = preload("res://addons/mat_maker_gd/widgets/curve_edit/curve_edit.tscn")

var slot_colors : PoolColorArray

var _material : MMMateial  = null
var _node : MMNode = null
var properties : Array = Array()

var _editor_node 
var _undo_redo : UndoRedo = null 
var _ignore_change_event : bool = false

func _init():
	show_close = true
	connect("dragged", self, "on_dragged")
	connect("close_request", self, "on_close_request")

func set_editor(editor_node) -> void:
	_editor_node = editor_node
	
	_undo_redo = _editor_node.get_undo_redo()

func ignore_changes(val : bool) -> void:
	_ignore_change_event = val
	_editor_node.ignore_changes(val)

func add_slot_texture(getter : String, setter : String) -> int:
	var t : TextureRect = TextureRect.new()
	t.rect_min_size = Vector2(128, 128)
	t.expand = true
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, t)
	
	t.texture = _node.call(getter, _material, slot_idx)
	properties[slot_idx].append(t.texture)
	
	return slot_idx

func add_slot_texture_universal(property : MMNodeUniversalProperty) -> int:
	var t : TextureRect = TextureRect.new()
	t.rect_min_size = Vector2(128, 128)
	t.expand = true
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", t)
	
	var img : Image = property.get_active_image()
	
	var tex : ImageTexture = ImageTexture.new()
	
	if img:
		tex.create_from_image(img, 0)
	
	t.texture = tex
	
	properties[slot_idx].append(property)
	
	property.connect("changed", self, "on_universal_texture_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_image_path_universal(property : MMNodeUniversalProperty, getter : String, setter : String) -> int:
	var t : TextureButton = load("res://addons/mat_maker_gd/widgets/image_picker_button/image_picker_button.tscn").instance()

	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", t)

	properties[slot_idx].append(property)
	properties[slot_idx].append(getter)
	properties[slot_idx].append(setter)
	
	property.connect("changed", self, "on_universal_texture_changed_image_picker", [ slot_idx ])
	
	t.connect("on_file_selected", self, "on_universal_image_path_changed", [ slot_idx ])
	
	t.call_deferred("do_set_image_path", _node.call(getter))
	
	return slot_idx


func add_slot_gradient() -> int:
	var ge : Control = gradient_editor_scene.instance()
	ge.graph_node = self
	ge.set_undo_redo(_undo_redo)

	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "", "", ge)
	
	ge.set_value(_node)
	#ge.texture = _node.call(getter, _material, slot_idx)
	#properties[slot_idx].append(ge.texture)
	
	return slot_idx

func add_slot_polygon() -> int:
	var ge : Control = polygon_edit_scene.instance()

	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "", "", ge)
	
	ge.set_value(_node)
	#ge.texture = _node.call(getter, _material, slot_idx)
	#properties[slot_idx].append(ge.texture)
	
	return slot_idx

func add_slot_curve() -> int:
	var ge : Control = curve_edit_scene.instance()

	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "", "", ge)
	
	ge.set_value(_node)
	#ge.texture = _node.call(getter, _material, slot_idx)
	#properties[slot_idx].append(ge.texture)
	
	return slot_idx

func add_slot_color(getter : String, setter : String) -> int:
	var cp : ColorPickerButton = ColorPickerButton.new()

	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, cp)
	
	cp.color = _node.call(getter)
	
	cp.connect("color_changed", _node, setter)
	
	return slot_idx

func add_slot_color_universal(property : MMNodeUniversalProperty) -> int:
	var cp : ColorPickerButton = ColorPickerButton.new()

	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", cp)
	
	cp.color = property.get_default_value()
	
	properties[slot_idx].append(property)
	
	cp.connect("color_changed", self, "on_universal_color_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_label(getter : String, setter : String, slot_name : String) -> int:
	var l : Label = Label.new()

	l.text = slot_name
	
	return add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, l)

func add_slot_line_edit(getter : String, setter : String, slot_name : String, placeholder : String = "") -> int:
	var bc : VBoxContainer = VBoxContainer.new()

	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var le : LineEdit = LineEdit.new()
	le.placeholder_text = placeholder
	bc.add_child(le)

	var slot_idx : int =  add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	
	le.text = _node.call(getter)
	
	le.connect("text_entered", self, "on_slot_line_edit_text_entered", [ slot_idx ])
	
	return slot_idx

func add_slot_enum(getter : String, setter : String, slot_name : String, values : Array) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	if slot_name:
		var l : Label = Label.new()
		l.text = slot_name
		bc.add_child(l)
	
	var mb : OptionButton = OptionButton.new()
	
	for v in values:
		mb.add_item(v)
	
	bc.add_child(mb)
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	
	mb.selected = _node.call(getter)
	
	mb.connect("item_selected", self, "on_slot_enum_item_selected", [ slot_idx ])
	
	return slot_idx

func add_slot_int(getter : String, setter : String, slot_name : String, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	sb.rounded = true
	sb.min_value = prange.x
	sb.max_value = prange.y
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	
	sb.value = _node.call(getter)
	
	sb.connect("value_changed", self, "on_int_spinbox_value_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_bool(getter : String, setter : String, slot_name : String) -> int:
	var cb : CheckBox = CheckBox.new()
	cb.text = slot_name
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, cb)
	
	cb.pressed = _node.call(getter)
	
	cb.connect("toggled", _node, setter)
	
	return slot_idx

func add_slot_label_universal(property : MMNodeUniversalProperty) -> int:
	var l : Label = Label.new()
	l.text = property.slot_name
	
	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", l)
	
	properties[slot_idx].append(property)
	
	return slot_idx

func add_slot_int_universal(property : MMNodeUniversalProperty) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = property.slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	sb.rounded = true
	sb.min_value = property.value_range.x
	sb.max_value = property.value_range.y
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", bc)
	
	sb.value = property.get_default_value()
	
	sb.connect("value_changed", self, "on_int_universal_spinbox_value_changed", [ slot_idx ])
	
	properties[slot_idx].append(property)
	
	return slot_idx

func add_slot_float(getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	sb.rounded = false
	sb.step = step
	sb.min_value = prange.x
	sb.max_value = prange.y
	sb.value = _node.call(getter)

	sb.connect("value_changed", self, "on_float_spinbox_value_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_float_universal(property : MMNodeUniversalProperty) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = property.slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", bc)
	sb.rounded = false
	sb.step = property.value_step
	sb.min_value = property.value_range.x
	sb.max_value = property.value_range.y
	sb.value = property.get_default_value()
	
	properties[slot_idx].append(property)

	sb.connect("value_changed", self, "on_float_universal_spinbox_value_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_vector2(getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sbx : SpinBox = SpinBox.new()
	bc.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	bc.add_child(sby)
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	sbx.rounded = false
	sby.rounded = false
	sbx.step = step
	sby.step = step
	sbx.min_value = prange.x
	sbx.max_value = prange.y
	sby.min_value = prange.x
	sby.max_value = prange.y
	
	var val : Vector2 = _node.call(getter)
	
	sbx.value = val.x
	sby.value = val.y

	sbx.connect("value_changed", self, "on_vector2_spinbox_value_changed", [ slot_idx, sbx, sby ])
	sby.connect("value_changed", self, "on_vector2_spinbox_value_changed", [ slot_idx, sbx, sby ])
	
	return slot_idx

func add_slot_vector3(getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sbx : SpinBox = SpinBox.new()
	bc.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	bc.add_child(sby)
	
	var sbz : SpinBox = SpinBox.new()
	bc.add_child(sbz)
	
	var slot_idx : int = add_slot(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, getter, setter, bc)
	sbx.rounded = false
	sby.rounded = false
	sbz.rounded = false
	sbx.step = step
	sby.step = step
	sbz.step = step
	sbx.min_value = prange.x
	sbx.max_value = prange.y
	sby.min_value = prange.x
	sby.max_value = prange.y
	sbz.min_value = prange.x
	sbz.max_value = prange.y
	
	var val : Vector3 = _node.call(getter)
	
	sbx.value = val.x
	sby.value = val.y
	sbz.value = val.z

	sbx.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	sby.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	sbz.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	
	return slot_idx

func add_slot_vector2_universal(property : MMNodeUniversalProperty) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = property.slot_name
	bc.add_child(l)
	
	var sbx : SpinBox = SpinBox.new()
	bc.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	bc.add_child(sby)
	
	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", bc)
	sbx.rounded = false
	sby.rounded = false
	sbx.step = property.value_step
	sby.step = property.value_step
	sbx.min_value = property.value_range.x
	sbx.max_value = property.value_range.y
	sby.min_value = property.value_range.x
	sby.max_value = property.value_range.y
	
	var val : Vector2 = property.get_default_value()
	
	sbx.value = val.x
	sby.value = val.y
	
	properties[slot_idx].append(property)

	sbx.connect("value_changed", self, "on_vector2_universal_spinbox_value_changed", [ slot_idx, sbx, sby ])
	sby.connect("value_changed", self, "on_vector2_universal_spinbox_value_changed", [ slot_idx, sbx, sby ])

	return slot_idx

func add_slot(input_type : int, output_type : int, getter : String, setter : String, control : Control) -> int:
	add_child(control)
	var slot_idx : int = get_child_count() - 1
	
	var arr : Array = Array()
	
	arr.append(slot_idx)
	arr.append(input_type)
	arr.append(output_type)
	arr.append(getter)
	arr.append(setter)
	arr.append(control)
	
	properties.append(arr)

	set_slot_enabled_left(slot_idx, input_type != -1)
	set_slot_enabled_right(slot_idx, output_type != -1)
	
	if input_type != -1:
		set_slot_type_left(slot_idx, input_type)
		
	if output_type != -1:
		set_slot_type_left(slot_idx, output_type)
		
	if input_type != -1 && slot_colors.size() > input_type:
		set_slot_color_left(slot_idx, slot_colors[input_type])
		
	if output_type != -1 && slot_colors.size() > output_type:
		set_slot_color_right(slot_idx, slot_colors[output_type])

	return slot_idx

func connect_slot(slot_idx : int, to_node : Node, to_slot_idx : int) -> bool:
	var from_property_index : int = -1
	var to_property_index : int = -1
	
	for i in range(properties.size()):
		if properties[i][2] != -1:
			from_property_index += 1
			
			if from_property_index == slot_idx:
				from_property_index = i
				break

	for i in range(to_node.properties.size()):
		if to_node.properties[i][1] != -1:
			to_property_index += 1
			
			if to_property_index == to_slot_idx:
				to_property_index = i
				break
	
	#to_node.properties[to_property_index][6].set_input_property(properties[from_property_index][6])
	
	_undo_redo.create_action("MMGD: connect_slot")
	_undo_redo.add_do_method(to_node.properties[to_property_index][6], "set_input_property", properties[from_property_index][6])
	_undo_redo.add_undo_method(to_node.properties[to_property_index][6], "set_input_property", to_node.properties[to_property_index][6].input_property)
	_undo_redo.commit_action()

	return true

func disconnect_slot(slot_idx : int, to_node : Node, to_slot_idx : int) -> bool:
	var from_property_index : int = -1
	var to_property_index : int = -1
	
	for i in range(properties.size()):
		if properties[i][2] != -1:
			from_property_index += 1
			
			if from_property_index == slot_idx:
				from_property_index = i
				break

	for i in range(to_node.properties.size()):
		if to_node.properties[i][1] != -1:
			to_property_index += 1
			
			if to_property_index == to_slot_idx:
				to_property_index = i
				break
	
	#to_node.properties[to_property_index][6].set_input_property(null)

	_undo_redo.create_action("MMGD: disconnect_slot")
	_undo_redo.add_do_method(to_node.properties[to_property_index][6], "unset_input_property")
	_undo_redo.add_undo_method(to_node.properties[to_property_index][6], "set_input_property", to_node.properties[to_property_index][6].input_property)
	_undo_redo.commit_action()

	return true

func get_input_property_graph_node_slot_index(property) -> int:
	var property_index : int = -1
	
	for i in range(properties.size()):
		if properties[i][1] != -1:
			property_index += 1
			
			if properties[i][6] == property:
				break
				
	return property_index

func get_output_property_graph_node_slot_index(property) -> int:
	var property_index : int = -1
	
	for i in range(properties.size()):
		if properties[i][2] != -1:
			property_index += 1
			
			if properties[i][6] == property:
				break
				
	return property_index

func get_property_control(slot_idx : int) -> Node:
	return properties[slot_idx][5]

func set_node(material : MMMateial, node : MMNode) -> void:
	_node = node
	_material = material
	
	if !_node:
		return
	
	title = _node.get_class()
	
	if _node.get_script():
		title = _node.get_script().resource_path.get_file().get_basename()
	
	_node.register_methods(self)
	
	offset = _node.get_graph_position()
	
	#_node.connect("changed", self, "on_node_changed")

func propagate_node_change() -> void:
	pass

func on_dragged(from : Vector2, to : Vector2):
	if _node:
		ignore_changes(true)
		#_node.set_graph_position(offset)
		
		_undo_redo.create_action("MMGD: value changed")
		_undo_redo.add_do_method(_node, "set_graph_position", to)
		_undo_redo.add_undo_method(_node, "set_graph_position", from)
		_undo_redo.commit_action()
		
		ignore_changes(false)

#func on_node_changed():
#	if _ignore_change_event:
#		return
#
#	_ignore_change_event = true
#	propagate_node_change()
#	_ignore_change_event = false
	
func on_int_spinbox_value_changed(val : float, slot_idx) -> void:
	#_node.call(properties[slot_idx][4], int(val))

	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], int(val))
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_float_spinbox_value_changed(val : float, slot_idx) -> void:
	#_node.call(properties[slot_idx][4], val)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], val)
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_vector2_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	var vv : Vector2 = Vector2(spinbox_x.value, spinbox_y.value)
	
	#_node.call(properties[slot_idx][4], vv)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], vv)
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_vector3_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y, spinbox_z) -> void:
	var vv : Vector3 = Vector3(spinbox_x.value, spinbox_y.value, spinbox_z.value)
	
	#_node.call(properties[slot_idx][4], vv)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], vv)
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_int_universal_spinbox_value_changed(val : float, slot_idx) -> void:
	#properties[slot_idx][6].set_default_value(int(val))
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(properties[slot_idx][6], "set_default_value", int(val))
	_undo_redo.add_undo_method(properties[slot_idx][6], "set_default_value", properties[slot_idx][6].get_default_value())
	_undo_redo.commit_action()
	ignore_changes(false)

func on_float_universal_spinbox_value_changed(val : float, slot_idx) -> void:
	#properties[slot_idx][6].set_default_value(val)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(properties[slot_idx][6], "set_default_value", val)
	_undo_redo.add_undo_method(properties[slot_idx][6], "set_default_value", properties[slot_idx][6].get_default_value())
	_undo_redo.commit_action()
	ignore_changes(false)

func on_vector2_universal_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	var vv : Vector2 = Vector2(spinbox_x.value, spinbox_y.value)
	
	#properties[slot_idx][6].set_default_value(vv)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(properties[slot_idx][6], "set_default_value", vv)
	_undo_redo.add_undo_method(properties[slot_idx][6], "set_default_value", properties[slot_idx][6].get_default_value())
	_undo_redo.commit_action()
	ignore_changes(false)
	
func on_slot_enum_item_selected(val : int, slot_idx : int) -> void:
	#_node.call(properties[slot_idx][4], val)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], val)
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_universal_texture_changed(slot_idx : int) -> void:
	ignore_changes(true)
	
	var img : Image = properties[slot_idx][6].get_active_image()
	
	var tex : ImageTexture = properties[slot_idx][5].texture
	
	if img:
		properties[slot_idx][5].texture.create_from_image(img, 0)
	else:
		properties[slot_idx][5].texture = ImageTexture.new()
		
	ignore_changes(false)

func on_universal_texture_changed_image_picker(slot_idx : int) -> void:
	ignore_changes(true)
	
	var img : Image = properties[slot_idx][6].get_active_image()
	
	var tex : ImageTexture = properties[slot_idx][5].texture_normal
	
	if img:
		properties[slot_idx][5].texture_normal.create_from_image(img, 0)
	else:
		properties[slot_idx][5].texture_normal = ImageTexture.new()
		
	ignore_changes(false)

func on_slot_line_edit_text_entered(text : String, slot_idx : int) -> void:
	#_node.call(properties[slot_idx][4], text)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(_node, properties[slot_idx][4], text)
	_undo_redo.add_undo_method(_node, properties[slot_idx][4], _node.call(properties[slot_idx][3]))
	_undo_redo.commit_action()
	ignore_changes(false)

func on_universal_color_changed(c : Color, slot_idx : int) -> void:
	#properties[slot_idx][6].set_default_value(c)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(properties[slot_idx][6], "set_default_value", c)
	_undo_redo.add_undo_method(properties[slot_idx][6], "set_default_value", properties[slot_idx][6].get_default_value())
	_undo_redo.commit_action()
	ignore_changes(false)

func on_universal_image_path_changed(f : String, slot_idx : int) -> void:
	_node.call(properties[slot_idx][8], f)
	
	ignore_changes(true)
	_undo_redo.create_action("MMGD: value changed")
	_undo_redo.add_do_method(properties[slot_idx][6], "set_default_value", f)
	_undo_redo.add_undo_method(properties[slot_idx][6], "set_default_value", properties[slot_idx][6].get_default_value())
	_undo_redo.commit_action()
	ignore_changes(false)

func get_material_node() -> MMNode:
	return _node

func on_close_request() -> void:
	var n : Node = get_parent()
	
	while n:
		if n.has_method("on_graph_node_close_request"):
			n.call_deferred("on_graph_node_close_request", self)
			return
			
		n = n.get_parent()
