tool
extends ScrollContainer

var EditorResourceWidget : PackedScene = preload("res://addons/world_generator/widgets/EditorResourceWidget.tscn")

var _edited_resource : WorldGenBaseResource = null
var properties : Array = Array()

var _ignore_changed_evend : bool = false
var _refresh_queued : bool = false

var _plugin : EditorPlugin = null
var _undo_redo : UndoRedo = null

func set_plugin(plugin : EditorPlugin) -> void:
	_plugin = plugin
	_undo_redo = _plugin.get_undo_redo()

func add_h_separator() -> int:
	var hsep : HSeparator = HSeparator.new()
	
	var content_node = $MainContainer/Content
	
	content_node.add_child(hsep)
	var slot_idx : int = content_node.get_child_count() - 1
	
	return slot_idx

func add_slot_color(getter : String, setter : String) -> int:
	var cp : ColorPickerButton = ColorPickerButton.new()

	var slot_idx : int = add_slot(getter, setter, cp)
	
	cp.color = _edited_resource.call(getter)
	
	cp.connect("color_changed", _edited_resource, setter)
	
	return slot_idx

func add_slot_label(getter : String, setter : String, slot_name : String) -> int:
	var l : Label = Label.new()

	l.text = slot_name
	
	return add_slot(getter, setter, l)

func add_slot_resource(getter : String, setter : String, slot_name : String, resource_type : String = "Resource") -> int:
	var bc : HBoxContainer = HBoxContainer.new()
	bc.set_h_size_flags(SIZE_EXPAND_FILL)
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var r : Control = EditorResourceWidget.instance()
	r.set_plugin(_plugin)
	r.set_resource_type(resource_type)
	r.set_resource(_edited_resource.call(getter))
	r.set_h_size_flags(SIZE_EXPAND_FILL)
	
	bc.add_child(r)
	
	var slot_idx : int =  add_slot(getter, setter, bc)
	
	r.connect("on_resource_changed", self, "on_widget_resource_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_line_edit(getter : String, setter : String, slot_name : String, placeholder : String = "") -> int:
	var bc : HBoxContainer = HBoxContainer.new()
	bc.set_h_size_flags(SIZE_EXPAND_FILL)

	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var le : LineEdit = LineEdit.new()
	le.placeholder_text = placeholder
	le.set_h_size_flags(SIZE_EXPAND_FILL)
	bc.add_child(le)
	
	var slot_idx : int = add_slot(getter, setter, bc)
	
	le.text = _edited_resource.call(getter)
	
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
	
	var slot_idx : int = add_slot(getter, setter, bc)
	
	mb.selected = _edited_resource.call(getter)
	
	mb.connect("item_selected", self, "on_slot_enum_item_selected", [ slot_idx ])
	
	return slot_idx

func add_slot_int(getter : String, setter : String, slot_name : String, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : HBoxContainer = HBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
#	l.size_flags_horizontal = SIZE_EXPAND_FILL
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	sb.rounded = true
	sb.min_value = prange.x
	sb.max_value = prange.y
	sb.set_h_size_flags(SIZE_EXPAND_FILL)
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(getter, setter, bc)
	
	sb.value = _edited_resource.call(getter)
	
	sb.connect("value_changed", self, "on_int_spinbox_value_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_bool(getter : String, setter : String, slot_name : String) -> int:
	var cb : CheckBox = CheckBox.new()
	cb.text = slot_name
	
	var slot_idx : int = add_slot(getter, setter, cb)
	
	cb.pressed = _edited_resource.call(getter)
	
	cb.connect("toggled", self, "on_checkbox_value_changed", [ slot_idx ])
	
	return slot_idx

func add_slot_float(getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-1000, 1000)) -> int:
	var bc : HBoxContainer = HBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
#	l.size_flags_horizontal = SIZE_EXPAND_FILL
	bc.add_child(l)
	
	var sb : SpinBox = SpinBox.new()
	bc.add_child(sb)
	
	var slot_idx : int = add_slot(getter, setter, bc)
	sb.rounded = false
	sb.step = step
	sb.min_value = prange.x
	sb.max_value = prange.y
	sb.value = _edited_resource.call(getter)
	sb.set_h_size_flags(SIZE_EXPAND_FILL)

	sb.connect("value_changed", self, "on_float_spinbox_value_changed", [ slot_idx ])
	
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
	
	var slot_idx : int = add_slot(getter, setter, bc)
	sbx.rounded = false
	sby.rounded = false
	sbx.step = step
	sby.step = step
	sbx.min_value = prange.x
	sbx.max_value = prange.y
	sby.min_value = prange.x
	sby.max_value = prange.y
	
	var val : Vector2 = _edited_resource.call(getter)
	
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
	
	var slot_idx : int = add_slot(getter, setter, bc)
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
	
	var val : Vector3 = _edited_resource.call(getter)
	
	sbx.value = val.x
	sby.value = val.y
	sbz.value = val.z

	sbx.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	sby.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	sbz.connect("value_changed", self, "on_vector3_spinbox_value_changed", [ slot_idx, sbx, sby, sbz ])
	
	return slot_idx


func add_slot_rect2(getter : String, setter : String, slot_name : String, step : float = 0.1, prange : Vector2 = Vector2(-10000, 10000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	bc.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var hc1 : HBoxContainer = HBoxContainer.new()
	hc1.size_flags_horizontal = SIZE_EXPAND_FILL
	bc.add_child(hc1)
	
	var sbx : SpinBox = SpinBox.new()
	sbx.size_flags_horizontal = SIZE_EXPAND_FILL
	hc1.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	sby.size_flags_horizontal = SIZE_EXPAND_FILL
	hc1.add_child(sby)
	
	var hc2 : HBoxContainer = HBoxContainer.new()
	hc2.size_flags_horizontal = SIZE_EXPAND_FILL
	bc.add_child(hc2)
	
	var sbw : SpinBox = SpinBox.new()
	sbw.size_flags_horizontal = SIZE_EXPAND_FILL
	hc2.add_child(sbw)
	
	var sbh : SpinBox = SpinBox.new()
	sbh.size_flags_horizontal = SIZE_EXPAND_FILL
	hc2.add_child(sbh)
	
	var slot_idx : int = add_slot(getter, setter, bc)
	sbx.rounded = false
	sby.rounded = false
	sbw.rounded = false
	sbh.rounded = false
	sbx.step = step
	sby.step = step
	sbw.step = step
	sbh.step = step
	sbx.min_value = prange.x
	sbx.max_value = prange.y
	sby.min_value = prange.x
	sby.max_value = prange.y
	sbw.min_value = prange.x
	sbw.max_value = prange.y
	sbh.min_value = prange.x
	sbh.max_value = prange.y
	
	var val : Rect2 = _edited_resource.call(getter)
	
	sbx.value = val.position.x
	sby.value = val.position.y
	sbw.value = val.size.x
	sbh.value = val.size.y

	sbx.connect("value_changed", self, "on_rect2_spinbox_value_changed", [ slot_idx, [ sbx, sby, sbw, sbh ] ])
	sby.connect("value_changed", self, "on_rect2_spinbox_value_changed", [ slot_idx, [ sbx, sby, sbw, sbh ] ])
	sbw.connect("value_changed", self, "on_rect2_spinbox_value_changed", [ slot_idx, [ sbx, sby, sbw, sbh ] ])
	sbh.connect("value_changed", self, "on_rect2_spinbox_value_changed", [ slot_idx, [ sbx, sby, sbw, sbh ] ])
	
	return slot_idx

func add_slot_vector2i(getter : String, setter : String, slot_name : String, step : int = 1, prange : Vector2i = Vector2i(-1000000, 1000000)) -> int:
	var bc : VBoxContainer = VBoxContainer.new()
	
	var l : Label = Label.new()
	l.text = slot_name
	bc.add_child(l)
	
	var sbx : SpinBox = SpinBox.new()
	bc.add_child(sbx)
	
	var sby : SpinBox = SpinBox.new()
	bc.add_child(sby)
	
	var slot_idx : int = add_slot(getter, setter, bc)
	sbx.rounded = true
	sby.rounded = true
	sbx.step = step
	sby.step = step
	sbx.min_value = prange.x
	sbx.max_value = prange.y
	sby.min_value = prange.x
	sby.max_value = prange.y
	
	var val : Vector2 = _edited_resource.call(getter)
	
	sbx.value = val.x
	sby.value = val.y

	sbx.connect("value_changed", self, "on_vector2i_spinbox_value_changed", [ slot_idx, sbx, sby ])
	sby.connect("value_changed", self, "on_vector2i_spinbox_value_changed", [ slot_idx, sbx, sby ])
	
	return slot_idx

func add_slot(getter : String, setter : String, control : Control) -> int:
	var content_node = $MainContainer/Content
	
	content_node.add_child(control)
	var child_idx : int = content_node.get_child_count() - 1
	
	var arr : Array = Array()
	
	arr.append(child_idx)
	arr.append(getter)
	arr.append(setter)
	arr.append(control)
	
	properties.append(arr)
	
	var slot_idx : int = properties.size() - 1

	return slot_idx

func get_property_control(slot_idx : int) -> Node:
	return properties[slot_idx][3]

func on_int_spinbox_value_changed(val : float, slot_idx) -> void:
	_ignore_changed_evend = true
	
	#_edited_resource.call(properties[slot_idx][2], int(val))
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], int(val))
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_checkbox_value_changed(val : bool, slot_idx) -> void:
	_ignore_changed_evend = true
	
	#_edited_resource.call(properties[slot_idx][2], val)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], val)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_float_spinbox_value_changed(val : float, slot_idx) -> void:
	_ignore_changed_evend = true
	
	#_edited_resource.call(properties[slot_idx][2], val)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], val)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_vector2_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	_ignore_changed_evend = true
	var vv : Vector2 = Vector2(spinbox_x.value, spinbox_y.value)
	
	#_edited_resource.call(properties[slot_idx][2], vv)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], vv)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_vector3_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y, spinbox_z) -> void:
	_ignore_changed_evend = true
	var vv : Vector3 = Vector3(spinbox_x.value, spinbox_y.value, spinbox_z.value)
	
	#_edited_resource.call(properties[slot_idx][2], vv)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], vv)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_rect2_spinbox_value_changed(val : float, slot_idx, spinboxes) -> void:
	_ignore_changed_evend = true
	var vv : Rect2 = Rect2(spinboxes[0].value, spinboxes[1].value, spinboxes[2].value, spinboxes[3].value)
	
	#_edited_resource.call(properties[slot_idx][2], vv)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], vv)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_vector2i_spinbox_value_changed(val : float, slot_idx, spinbox_x, spinbox_y) -> void:
	_ignore_changed_evend = true
	var vv : Vector2i = Vector2i(spinbox_x.value, spinbox_y.value)
	
	#_edited_resource.call(properties[slot_idx][2], vv)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], vv)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_slot_enum_item_selected(val : int, slot_idx : int) -> void:
	_ignore_changed_evend = true
	#_edited_resource.call(properties[slot_idx][2], val)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], val)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_slot_line_edit_text_entered(text : String, slot_idx : int) -> void:
	_ignore_changed_evend = true
	#_edited_resource.call(properties[slot_idx][2], text)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], text)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func on_widget_resource_changed(res : Resource, slot_idx : int) -> void:
	_ignore_changed_evend = true
	#_edited_resource.call(properties[slot_idx][2], res)
	
	_undo_redo.create_action("WE: Set Value")
	_undo_redo.add_do_method(_edited_resource, properties[slot_idx][2], res)
	_undo_redo.add_undo_method(_edited_resource, properties[slot_idx][2], _edited_resource.call(properties[slot_idx][1]))
	_undo_redo.commit_action()
	
	_ignore_changed_evend = false

func clear() -> void:
	properties.clear()

	var content_node = $MainContainer/Content
	
	if !content_node:
		return
	
	for c in content_node.get_children():
		c.queue_free()
		content_node.remove_child(c)

func refresh() -> void:
	clear()
	
	var cls_str : String = "[none]"
	var script_str : String = "[none]"
	
	if _edited_resource:
		cls_str = _edited_resource.get_class()
		
		var scr = _edited_resource.get_script()
		
		if scr:
			script_str = scr.resource_path
		
		_edited_resource.setup_property_inspector(self)
		
	$MainContainer/HBoxContainer/ClassLE.text = cls_str
	$MainContainer/HBoxContainer2/ScriptLE.text = script_str
	
	_refresh_queued = false

func edit_resource(wgw) -> void:
	if _edited_resource:
		_edited_resource.disconnect("changed", self, "on_edited_resource_changed")
	
	_edited_resource = wgw
	
	#if !_edited_resource.is_connected("changed", self, "on_edited_resource_changed"):
	if _edited_resource:
		_edited_resource.connect("changed", self, "on_edited_resource_changed")
	
	refresh()

func on_edited_resource_changed() -> void:
	if _ignore_changed_evend:
		return
	
	if _refresh_queued:
		return
		
	_refresh_queued = true
	call_deferred("refresh")
