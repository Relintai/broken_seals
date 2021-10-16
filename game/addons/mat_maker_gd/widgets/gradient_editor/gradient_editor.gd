extends Control

class GradientCursor:
	extends Control

	var color : Color
	var sliding : bool = false

	onready var label : Label = get_parent().get_node("Value")

	const WIDTH : int = 10

	func _ready() -> void:
		rect_position = Vector2(0, 15)
		rect_size = Vector2(WIDTH, 15)

	func _draw() -> void:
# warning-ignore:integer_division
		var polygon : PoolVector2Array = PoolVector2Array([Vector2(0, 5), Vector2(WIDTH/2, 0), Vector2(WIDTH, 5), Vector2(WIDTH, 15), Vector2(0, 15), Vector2(0, 5)])
		var c = color
		c.a = 1.0
		draw_colored_polygon(polygon, c)
		draw_polyline(polygon, Color(0.0, 0.0, 0.0) if color.v > 0.5 else Color(1.0, 1.0, 1.0))

	func _gui_input(ev) -> void:
		if ev is InputEventMouseButton:
			if ev.button_index == BUTTON_LEFT:
				if ev.doubleclick:
					get_parent().select_color(self, ev.global_position)
				elif ev.pressed:
					sliding = true
					label.visible = true
					label.text = "%.03f" % get_cursor_position()
				else:
					sliding = false
					label.visible = false
			elif ev.button_index == BUTTON_RIGHT and get_parent().get_sorted_cursors().size() > 2:
				var parent = get_parent()
				parent.remove_child(self)
				parent.update_value()
				queue_free()
		elif ev is InputEventMouseMotion and (ev.button_mask & BUTTON_MASK_LEFT) != 0 and sliding:
			rect_position.x += get_local_mouse_position().x
			if ev.control:
				rect_position.x = round(get_cursor_position()*20.0)*0.05*(get_parent().rect_size.x - WIDTH)
			rect_position.x = min(max(0, rect_position.x), get_parent().rect_size.x-rect_size.x)
			get_parent().update_value()
			label.text = "%.03f" % get_cursor_position()

	func get_cursor_position() -> float:
		return rect_position.x / (get_parent().rect_size.x - WIDTH)

	func set_color(c) -> void:
		color = c
		get_parent().update_value()
		update()

	static func sort(a, b) -> bool:
		return a.get_position() < b.get_position()

	func can_drop_data(_position, data) -> bool:
		return typeof(data) == TYPE_COLOR

	func drop_data(_position, data) -> void:
		set_color(data)


var value = null setget set_value
export var embedded : bool = true

signal updated(value)

func _ready() -> void:
	$Gradient.material = $Gradient.material.duplicate(true)
	#set_value(MMGradient.new())

func get_gradient_from_data(data):
	if typeof(data) == TYPE_ARRAY:
		return data
	elif typeof(data) == TYPE_DICTIONARY:
		if data.has("parameters") and data.parameters.has("gradient"):
			return data.parameters.gradient
		if data.has("type") and data.type == "Gradient":
			return data
	return null

func get_drag_data(_position : Vector2):
	var data = 0#MMType.serialize_value(value)
	var preview = ColorRect.new()
	preview.rect_size = Vector2(64, 24)
	preview.material = $Gradient.material
	set_drag_preview(preview)
	return data

func can_drop_data(_position : Vector2, data) -> bool:
	return get_gradient_from_data(data) != null

func drop_data(_position : Vector2, data) -> void:
	var gradient = get_gradient_from_data(data)
	#if gradient != null:
		#set_value(MMType.deserialize_value(gradient))

func set_value(v) -> void:
	value = v
	for c in get_children():
		if c is GradientCursor:
			remove_child(c)
			c.free()
	for p in value.points:
		add_cursor(p.v*(rect_size.x-GradientCursor.WIDTH), p.c)
	$Interpolation.selected = value.interpolation
	update_shader()

func update_value() -> void:
	value.clear()
	for c in get_children():
		if c is GradientCursor:
			value.add_point(c.rect_position.x/(rect_size.x-GradientCursor.WIDTH), c.color)
	update_shader()

func add_cursor(x, color) -> void:
	var cursor = GradientCursor.new()
	add_child(cursor)
	cursor.rect_position.x = x
	cursor.color = color

func _gui_input(ev) -> void:
	if ev is InputEventMouseButton and ev.button_index == 1 and ev.doubleclick:
		if ev.position.y > 15:
			var p = clamp(ev.position.x, 0, rect_size.x-GradientCursor.WIDTH)
			add_cursor(p, get_gradient_color(p))
			update_value()
		elif embedded:
			var popup = load("res://material_maker/widgets/gradient_editor/gradient_popup.tscn").instance()
			add_child(popup)
			var popup_size = popup.rect_size
			popup.popup(Rect2(ev.global_position, Vector2(0, 0)))
			popup.set_global_position(ev.global_position-Vector2(popup_size.x / 2, popup_size.y))
			popup.init(value)
			popup.connect("updated", self, "set_value")
			popup.connect("popup_hide", popup, "queue_free")

# Showing a color picker popup to change a cursor's color

var active_cursor

func select_color(cursor, position) -> void:
	active_cursor = cursor
	var color_picker_popup = preload("res://addons/mat_maker_gd/widgets/color_picker_popup/color_picker_popup.tscn").instance()
	add_child(color_picker_popup)
	var color_picker = color_picker_popup.get_node("ColorPicker")
	color_picker.color = cursor.color
	color_picker.connect("color_changed", cursor, "set_color")
	color_picker_popup.rect_position = position
	color_picker_popup.connect("popup_hide", color_picker_popup, "queue_free")
	color_picker_popup.popup()

# Calculating a color from the gradient and generating the shader

func get_sorted_cursors() -> Array:
	var array = []
	for c in get_children():
		if c is GradientCursor:
			array.append(c)
	array.sort_custom(GradientCursor, "sort")
	return array

func get_gradient_color(x) -> Color:
	return value.get_color(x / (rect_size.x - GradientCursor.WIDTH))

func update_shader() -> void:
	var shader
	shader = "shader_type canvas_item;\n"
	var params = value.get_shader_params("")
	for sp in params.keys():
		shader += "uniform float "+sp+" = "+str(params[sp])+";\n"
	shader += value.get_shader("")
	shader += "void fragment() { COLOR = _gradient_fct(UV.x); }"
	$Gradient.material.shader.set_code(shader)
	emit_signal("updated", value)

func _on_Interpolation_item_selected(ID) -> void:
	value.interpolation = ID
	update_shader()
