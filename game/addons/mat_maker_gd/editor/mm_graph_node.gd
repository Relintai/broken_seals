tool
extends GraphNode

var slot_colors : PoolColorArray

var _material : MMMateial  = null
var _node : MMNode = null
var properties : Array = Array()

func _init():
	show_close = true
	connect("offset_changed", self, "on_offset_changed")
	
func add_slot_texture(input_type : int, output_type : int, getter : String, setter : String) -> int:
	var t : TextureRect = TextureRect.new()

	var slot_idx : int = add_slot(input_type, output_type, getter, setter, t)
	
	t.texture = _node.call(getter, _material, slot_idx)
	properties[slot_idx].append(t.texture)
	
	return slot_idx
	
func add_slot_texture_universal(property : MMNodeUniversalProperty) -> int:
	var t : TextureRect = TextureRect.new()

	var slot_idx : int = add_slot(property.input_slot_type, property.output_slot_type, "", "", t)
	
	var img : Image = property.get_active_image()
	
	var tex : ImageTexture = ImageTexture.new()
	
	if img:
		tex.create_from_image(img, 0)
	
	t.texture = tex
	
	properties[slot_idx].append(property)
	
	property.connect("changed", self, "on_universal_texture_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_label(input_type : int, output_type : int, getter : String, setter : String, slot_name : String) -> int:
	var l : Label = Label.new()

	l.text = slot_name
	
	return add_slot(input_type, output_type, getter, setter, l)

func add_slot_line_edit(input_type : int, output_type : int, getter : String, setter : String, slot_name : String, placeholder : String = "") -> int:
	var bc : VBoxContainer = VBoxContainer.new()

	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var le : LineEdit = LineEdit.new()
	le.placeholder_text = placeholder
	bc.add_child(le)

	var slot_idx : int =  add_slot(input_type, output_type, getter, setter, bc)
	
	le.text = _node.call(getter)
	
	le.connect("text_entered", self, "on_slot_line_edit_text_entered", [ slot_idx ])
	
	return slot_idx

func add_slot_enum(input_type : int, output_type : int, getter : String, setter : String, slot_name : String, values : Array) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var mb : OptionButton = OptionButton.new()
	
	for v in values:
		mb.add_item(v)
	
	bc.add_child(mb)
	
	var slot_idx : int = add_slot(input_type, output_type, getter, setter, bc)
	
	mb.selected = _node.call(getter)
	
	mb.connect("item_selected", self, "on_slot_enum_item_selected", [ slot_idx ])
	
	return slot_idx

func add_slot_int(input_type : int, output_type : int, getter : String, setter : String, slot_name : String, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	sb.rounded = true
	sb.min_value = prange.x
	sb.max_value = prange.y
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(input_type, output_type, getter, setter, bc)
	
	sb.value = _node.call(getter)
	
	sb.connect("value_changed", self, "on_int_spinbox_value_changed", [ slot_idx ])
	
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

func add_slot_float(input_type : int, output_type : int, getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(input_type, output_type, getter, setter, bc)
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

func add_slot_vector2(input_type : int, output_type : int, getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sbx : SpinBox = SpinBox.new()
	bc.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	bc.add_child(sby)
	
	var slot_idx : int = add_slot(input_type, output_type, getter, setter, bc)
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
	
	_node.connect("changed", self, "on_node_changed")

func propagate_node_change() -> void:
	pass

func on_offset_changed():
	if _node:
		_node.set_graph_position(offset)

func on_node_changed():
	#get all properties again
	#_node.recalculate_image(_material)
	
	propagate_node_change()
	
func on_int_spinbox_value_changed(val : float, slot_idx) -> void:
	_node.call(properties[slot_idx][4], int(val))

func on_float_spinbox_value_changed(val : float, slot_idx) -> void:
	_node.call(properties[slot_idx][4], val)

func on_vector2_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	var vv : Vector2 = Vector2(spinbox_x.value, spinbox_y.value)
	
	_node.call(properties[slot_idx][4], vv)

func on_int_universal_spinbox_value_changed(val : float, slot_idx) -> void:
	properties[slot_idx][6].set_default_value(int(val))

func on_float_universal_spinbox_value_changed(val : float, slot_idx) -> void:
	properties[slot_idx][6].set_default_value(val)

func on_vector2_universal_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	var vv : Vector2 = Vector2(spinbox_x.value, spinbox_y.value)
	
	properties[slot_idx][6].set_default_value(vv)
	
func on_slot_enum_item_selected(val : int, slot_idx : int) -> void:
	_node.call(properties[slot_idx][4], val)


func on_universal_texture_changed(slot_idx : int) -> void:
	var img : Image = properties[slot_idx][6].get_active_image()
	
	var tex : ImageTexture = properties[slot_idx][5].texture
	
	if img:
		properties[slot_idx][5].texture.create_from_image(img, 0)
	else:
		properties[slot_idx][5].texture = ImageTexture.new()

func on_slot_line_edit_text_entered(text : String, slot_idx : int) -> void:
	_node.call(properties[slot_idx][4], text)
