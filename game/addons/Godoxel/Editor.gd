tool
extends Control

enum Tools {
	PAINT,
	BRUSH,
	BUCKET,
	RAINBOW,
	LINE,
	RECT,
	DARKEN,
	BRIGHTEN
	COLORPICKER,
	CUT,
	PASTECUT,
}

# Keyboard shortcuts
const K_UNDO = KEY_Z
const K_REDO = KEY_Y
const K_PENCIL = KEY_Q
const K_BRUSH = KEY_W
const K_BUCKET = KEY_F
const K_RAINBOW = KEY_R
const K_LINE = KEY_L
const K_DARK = KEY_D
const K_BRIGHT = KEY_B
const K_CUT = KEY_C
const K_PICK = KEY_P


var layer_buttons: Control
var paint_canvas_container_node
var paint_canvas: GECanvas
var canvas_background: TextureRect
var grids_node
var colors_grid
var selected_color = Color(1, 1, 1, 1) setget set_selected_color
var util = preload("res://addons/Godoxel/Util.gd")
var textinfo
var allow_drawing = true

var mouse_in_region = false
var mouse_on_top = false


var _middle_mouse_pressed_pos = null
var _middle_mouse_pressed_start_pos = null
var _left_mouse_pressed_start_pos = Vector2()
var _previous_tool
var brush_mode

var _layer_button_ref = {}

var _total_added_layers = 1

var selected_brush_prefab = 0
var _last_drawn_pixel = Vector2.ZERO
var _last_preview_draw_cell_pos = Vector2.ZERO

var _selection_cells = []
var _selection_colors = []

var _cut_pos = Vector2.ZERO
var _cut_size = Vector2.ZERO

var _actions_history = [] # for undo
var _redo_history = []
var _current_action

var _last_mouse_pos_canvas_area = Vector2.ZERO

var _picked_color = false

var mouse_position = Vector2()
var canvas_position = Vector2()
var canvas_mouse_position = Vector2()
var cell_mouse_position = Vector2()
var cell_color = Color()

var last_mouse_position = Vector2()
var last_canvas_position = Vector2()
var last_canvas_mouse_position = Vector2()
var last_cell_mouse_position = Vector2()
var last_cell_color = Color()

const current_layer_highlight = Color(0.354706, 0.497302, 0.769531)
const other_layer_highlight = Color(0.180392, 0.176471, 0.176471)
const locked_layer_highlight = Color(0.098039, 0.094118, 0.094118)

var big_grid_pixels = 4 # 1 grid-box is big_grid_pixels big



func _ready():
	#--------------------
	#Setup nodes
	#--------------------
	
	paint_canvas_container_node = find_node("PaintCanvasContainer")
	textinfo = find_node("DebugTextDisplay")
	selected_color = find_node("ColorPicker").color
	colors_grid = find_node("Colors")
	paint_canvas = paint_canvas_container_node.find_node("Canvas")
	layer_buttons = find_node("LayerButtons")
	canvas_background = find_node("CanvasBackground")
	
	set_process(true)
	
	#--------------------
	#connect nodes
	#--------------------
	if not colors_grid.is_connected("color_change_request", self, "change_color"):
		colors_grid.connect("color_change_request", self, "change_color")
	
	if not is_connected("visibility_changed", self, "_on_Editor_visibility_changed"):
		connect("visibility_changed", self, "_on_Editor_visibility_changed")
	
	find_node("CanvasBackground").material.set_shader_param(
			"pixel_size", 8 * pow(0.5, big_grid_pixels)/paint_canvas.pixel_size)
	
	# ready
	
	set_brush(Tools.PAINT)
	_layer_button_ref[layer_buttons.get_child(0).name] = layer_buttons.get_child(0) #ugly
	_connect_layer_buttons()
	highlight_layer(paint_canvas.get_active_layer().name)
	
	find_node("BrushSizeLabel").text = str(int(find_node("BrushSize").value))
	
	paint_canvas.update()


func _input(event):
	if is_any_menu_open():
		return
	if not is_visible_in_tree():
		return
	if paint_canvas_container_node == null or paint_canvas == null:
		return
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		_handle_shortcuts(event.scancode)
	
	if is_mouse_in_canvas() and paint_canvas.mouse_on_top:
		_handle_zoom(event)
	
	if paint_canvas.is_active_layer_locked():
		return
	
	if brush_mode == Tools.CUT:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if not event.pressed:
					commit_action()
	
	if (paint_canvas.mouse_in_region and paint_canvas.mouse_on_top):
		if event is InputEventMouseButton:
			match brush_mode:
				Tools.BUCKET:
					if event.button_index == BUTTON_LEFT:
						if event.pressed:
							if _current_action == null:
								_current_action = get_action()
							do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
					
				Tools.COLORPICKER:
					if event.button_index == BUTTON_LEFT:
						if event.pressed:
							if paint_canvas.get_pixel(cell_mouse_position.x, cell_mouse_position.y).a == 0:
								return
							selected_color = paint_canvas.get_pixel(cell_mouse_position.x, cell_mouse_position.y)
							_picked_color = true
							find_node("Colors").add_color_prefab(selected_color)
						elif _picked_color:
							set_brush(_previous_tool)
					elif event.button_index == BUTTON_RIGHT:
						if event.pressed:
							set_brush(_previous_tool)
						
				Tools.PASTECUT:
					if event.button_index == BUTTON_RIGHT:
						if event.pressed:
							commit_action()
							set_brush(Tools.PAINT)


func _process(delta):
	if not is_visible_in_tree():
		return
	if paint_canvas_container_node == null or paint_canvas == null:
		return
	if is_any_menu_open():
		return
	
	if is_mouse_in_canvas():
		_handle_scroll()
	
	#Update commonly used variables
	var grid_size = paint_canvas.pixel_size
	mouse_position = get_global_mouse_position() #paint_canvas.get_local_mouse_position()
	canvas_position = paint_canvas.rect_global_position
	canvas_mouse_position = Vector2(mouse_position.x - canvas_position.x, mouse_position.y - canvas_position.y)
	
	if is_mouse_in_canvas() && paint_canvas.mouse_on_top:
		cell_mouse_position = Vector2(
				floor(canvas_mouse_position.x / grid_size), 
				floor(canvas_mouse_position.y / grid_size))
		cell_color = paint_canvas.get_pixel(cell_mouse_position.x, cell_mouse_position.y)
		
	update_text_info()
	
#	if not is_mouse_in_canvas():
#		paint_canvas.tool_layer.clear()
#		paint_canvas.update()
#		paint_canvas.tool_layer.update_texture()
#	else:
	if is_mouse_in_canvas() && paint_canvas.mouse_on_top:
		if not paint_canvas.is_active_layer_locked():
			if is_position_in_canvas(get_global_mouse_position()) or \
					is_position_in_canvas(_last_mouse_pos_canvas_area):
				brush_process()
			else:
				print(cell_mouse_position, " not in ", paint_canvas_container_node.rect_size)
				print("not in canvas")
		
		_draw_tool_brush()
	
	#Update last variables with the current variables
	last_mouse_position = mouse_position
	last_canvas_position = canvas_position
	last_canvas_mouse_position = canvas_mouse_position
	last_cell_mouse_position = cell_mouse_position
	last_cell_color = cell_color
	_last_mouse_pos_canvas_area = get_global_mouse_position() #paint_canvas_container_node.get_local_mouse_position()


func _handle_shortcuts(scancode):
	match scancode:
		K_UNDO:
			undo_action()
			
		K_REDO:
			redo_action()
			
		K_PENCIL:
			set_brush(Tools.PAINT)
			
		K_BRUSH:
			set_brush(Tools.BRUSH)
			
		K_BUCKET:
			set_brush(Tools.BUCKET)
			
		K_RAINBOW:
			set_brush(Tools.RAINBOW)
			
		K_LINE:
			set_brush(Tools.LINE)
			
		K_DARK:
			set_brush(Tools.DARKEN)
			
		K_BRIGHT:
			set_brush(Tools.BRIGHTEN)
			
		K_CUT:
			set_brush(Tools.CUT)
			
		K_PICK:
			set_brush(Tools.COLORPICKER)


func _draw_tool_brush():
	paint_canvas.tool_layer.clear()
	
	match brush_mode:
		Tools.PASTECUT:
			for idx in range(_selection_cells.size()):
				var pixel = _selection_cells[idx]
#				if pixel.x < 0 or pixel.y < 0:
#					print(pixel)
				var color = _selection_colors[idx]
				pixel -= _cut_pos + _cut_size / 2
				pixel += cell_mouse_position
				paint_canvas._set_pixel_v(paint_canvas.tool_layer, pixel, color)
		Tools.BRUSH:
			var pixels = BrushPrefabs.get_brush(selected_brush_prefab, find_node("BrushSize").value)
			for pixel in pixels:
				
				paint_canvas._set_pixel(paint_canvas.tool_layer, 
						cell_mouse_position.x + pixel.x, cell_mouse_position.y + pixel.y, selected_color)
		
		Tools.RAINBOW:
			paint_canvas._set_pixel(paint_canvas.tool_layer, 
					cell_mouse_position.x, cell_mouse_position.y, Color(0.46875, 0.446777, 0.446777, 0.196078))
		
		Tools.COLORPICKER:
			paint_canvas._set_pixel(paint_canvas.tool_layer, 
					cell_mouse_position.x, cell_mouse_position.y, Color(0.866667, 0.847059, 0.847059, 0.196078))
		_:
			paint_canvas._set_pixel(paint_canvas.tool_layer, 
					cell_mouse_position.x, cell_mouse_position.y, selected_color)
	
	paint_canvas.update()
	#TODO add here brush prefab drawing 
	paint_canvas.tool_layer.update_texture()


func _handle_scroll():
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		if _middle_mouse_pressed_start_pos == null:
			_middle_mouse_pressed_start_pos = paint_canvas.rect_position
			_middle_mouse_pressed_pos = get_global_mouse_position()
		
		paint_canvas.rect_position = _middle_mouse_pressed_start_pos
		paint_canvas.rect_position += get_global_mouse_position() - _middle_mouse_pressed_pos 
		
	elif _middle_mouse_pressed_start_pos != null:
		_middle_mouse_pressed_start_pos = null


const max_zoom_out = 1
const max_zoom_in = 50

func _handle_zoom(event):
	if not event is InputEventMouseButton:
		return
	if event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			var px = min(paint_canvas.pixel_size * 2, max_zoom_in)
			if px == paint_canvas.pixel_size:
				return
			paint_canvas.set_pixel_size(px)
			find_node("CanvasBackground").material.set_shader_param(
					"pixel_size", 8 * pow(0.5, big_grid_pixels)/paint_canvas.pixel_size)
			paint_canvas.rect_position -= paint_canvas.get_local_mouse_position()
			paint_canvas.rect_position.x = clamp(paint_canvas.rect_position.x, -paint_canvas.rect_size.x * 0.8, rect_size.x)
			paint_canvas.rect_position.y = clamp(paint_canvas.rect_position.y, -paint_canvas.rect_size.y * 0.8, rect_size.y)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			var px = max(paint_canvas.pixel_size / 2.0, max_zoom_out)
			if px == paint_canvas.pixel_size:
				return
			paint_canvas.set_pixel_size(px)
			find_node("CanvasBackground").material.set_shader_param(
					# 4 2 1
					"pixel_size", 8 * pow(0.5, big_grid_pixels)/paint_canvas.pixel_size)
			paint_canvas.rect_position += paint_canvas.get_local_mouse_position() / 2
			paint_canvas.rect_position.x = clamp(paint_canvas.rect_position.x, -paint_canvas.rect_size.x * 0.8, rect_size.x)
			paint_canvas.rect_position.y = clamp(paint_canvas.rect_position.y, -paint_canvas.rect_size.y * 0.8, rect_size.y)


func _handle_cut():
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		paint_canvas.clear_preview_layer()
		set_brush(_previous_tool)
		return
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		for pixel_pos in GEUtils.get_pixels_in_line(cell_mouse_position, last_cell_mouse_position):
			for idx in range(_selection_cells.size()):
				var pixel = _selection_cells[idx]
				var color = _selection_colors[idx]
				pixel -= _cut_pos + _cut_size / 2
				pixel += pixel_pos
				paint_canvas.set_pixel_v(pixel, color)
	else:
		if _last_preview_draw_cell_pos == cell_mouse_position:
			return
		paint_canvas.clear_preview_layer()
		for idx in range(_selection_cells.size()):
			var pixel = _selection_cells[idx]
			var color = _selection_colors[idx]
			pixel -= _cut_pos + _cut_size / 2
			pixel += cell_mouse_position
			paint_canvas.set_preview_pixel_v(pixel, color)
		_last_preview_draw_cell_pos = cell_mouse_position


func brush_process():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if _current_action == null:
			_current_action = get_action()
		if brush_mode == Tools.COLORPICKER:
			_current_action = null
		
		match brush_mode:
			Tools.PAINT:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.BRUSH:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color, 
						selected_brush_prefab, find_node("BrushSize").value])
			Tools.LINE:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.RECT:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.DARKEN:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.BRIGHTEN:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.COLORPICKER:
				pass
			Tools.CUT:
				do_action([cell_mouse_position, last_cell_mouse_position, selected_color])
			Tools.PASTECUT:
				do_action([cell_mouse_position, last_cell_mouse_position, 
						_selection_cells, _selection_colors,
						_cut_pos, _cut_size])
			Tools.RAINBOW:
				do_action([cell_mouse_position, last_cell_mouse_position])
		paint_canvas.update()
	
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		paint_canvas.update()
		if _current_action == null:
			_current_action = get_action()
		
		match brush_mode:
			Tools.PAINT:
				do_action([cell_mouse_position, last_cell_mouse_position, Color.transparent])
			Tools.BRUSH:
				do_action([cell_mouse_position, last_cell_mouse_position, Color.transparent, 
						selected_brush_prefab, find_node("BrushSize").value])
	else:
		if _current_action and _current_action.can_commit():
			commit_action()
			paint_canvas.update()


func update_text_info():
	var text = ""
	
	var cell_color_text = cell_color
	cell_color_text = Color(0, 0, 0, 0)
	
	text += \
	str("FPS %s\t" + \
	"Mouse Position %s\t" + \
	"Canvas Mouse Position %s \t" + \
	"Canvas Position %s\t\n" + \
	"Cell Position %s \t" + \
	"Cell Color %s\t") % [
		str(Engine.get_frames_per_second()),
		str(mouse_position),
		str(canvas_mouse_position),
		str(canvas_position),
		str(cell_mouse_position),
		str(cell_color_text),
	]
	
	find_node("DebugTextDisplay").display_text(text)


func _on_Save_pressed():
	get_node("SaveFileDialog").show()



#---------------------------------------
# Actions
#---------------------------------------


func do_action(data: Array):
	if _current_action == null:
		#print("clear redo")
		_redo_history.clear()
	_current_action.do_action(paint_canvas, data)


func commit_action():
	if not _current_action:
		return
	
	#print("commit action")
	var commit_data = _current_action.commit_action(paint_canvas)
	var action = get_action()
	action.action_data = _current_action.action_data.duplicate(true)
	_actions_history.push_back(action)
	_redo_history.clear()
	
	match brush_mode:
		Tools.CUT:
			_cut_pos = _current_action.mouse_start_pos
			_cut_size = _current_action.mouse_end_pos - _current_action.mouse_start_pos
			_selection_cells = _current_action.action_data.redo.cells.duplicate()
			_selection_colors = _current_action.action_data.redo.colors.duplicate()
			set_brush(Tools.PASTECUT)
		_:
			_current_action = null


func redo_action():
	if _redo_history.empty():
		print("nothing to redo")
		return
	var action = _redo_history.pop_back()
	if not action:
		return 
	_actions_history.append(action)
	action.redo_action(paint_canvas)
	paint_canvas.update()
	#print("redo action")


func undo_action():
	var action = _actions_history.pop_back()
	if not action:
		return
	_redo_history.append(action)
	action.undo_action(paint_canvas)
	update()
	paint_canvas.update()
	#print("undo action")


func get_action():
	match brush_mode:
		Tools.PAINT:
			return GEPencil.new()
		Tools.BRUSH:
			return GEBrush.new()
		Tools.LINE:
			return GELine.new()
		Tools.RAINBOW:
			return GERainbow.new()
		Tools.BUCKET:
			return GEBucket.new()
		Tools.RECT:
			return GERect.new()
		Tools.DARKEN:
			return GEDarken.new()
		Tools.BRIGHTEN:
			return GEBrighten.new()
		Tools.CUT:
			return GECut.new()
		Tools.PASTECUT:
			return GEPasteCut.new()
		_:
			#print("no tool!")
			return null


############################################
# Brushes
############################################


func set_selected_color(color):
	selected_color = color


func set_brush(new_mode):
	if brush_mode == new_mode:
		return
	_previous_tool = brush_mode
	brush_mode = new_mode
	
	_current_action = get_action()
	
	match _previous_tool:
		Tools.CUT:
			paint_canvas.clear_preview_layer()
		Tools.PASTECUT:
			_selection_cells.clear()
			_selection_colors.clear()
		Tools.BUCKET:
			_current_action = null
	#print("Selected: ", Tools.keys()[brush_mode])


func change_color(new_color):
	if new_color.a == 0:
		return
	selected_color = new_color
	find_node("ColorPicker").color = selected_color


func _on_ColorPicker_color_changed(color):
	selected_color = color


func _on_PaintTool_pressed():
	set_brush(Tools.PAINT)


func _on_BucketTool_pressed():
	set_brush(Tools.BUCKET)


func _on_RainbowTool_pressed():
	set_brush(Tools.RAINBOW)


func _on_BrushTool_pressed():
	set_brush(Tools.BRUSH)


func _on_LineTool_pressed():
	set_brush(Tools.LINE)


func _on_RectTool_pressed():
	set_brush(Tools.RECT)


func _on_DarkenTool_pressed():
	set_brush(Tools.DARKEN)


func _on_BrightenTool_pressed():
	set_brush(Tools.BRIGHTEN)


func _on_ColorPickerTool_pressed():
	set_brush(Tools.COLORPICKER)


func _on_CutTool_pressed():
	set_brush(Tools.CUT)


func _on_Editor_visibility_changed():
	pause_mode = not visible



############################################
# Layer
############################################

func highlight_layer(layer_name: String):
	for button in layer_buttons.get_children():
		if paint_canvas.find_layer_by_name(button.name).locked:
			button.get("custom_styles/panel").set("bg_color", locked_layer_highlight)
		elif button.name == layer_name:
			button.get("custom_styles/panel").set("bg_color", current_layer_highlight)
		else:
			button.get("custom_styles/panel").set("bg_color", other_layer_highlight)


func toggle_layer_visibility(button, layer_name: String):
	#print("toggling: ", layer_name)
	paint_canvas.toggle_layer_visibility(layer_name)


func select_layer(layer_name: String):
	#print("select layer: ", layer_name)
	paint_canvas.select_layer(layer_name)
	highlight_layer(layer_name)


func lock_layer(button, layer_name: String):
	paint_canvas.toggle_lock_layer(layer_name)
	highlight_layer(paint_canvas.get_active_layer().name)


func add_new_layer():
	var new_layer_button = layer_buttons.get_child(0).duplicate()
	new_layer_button.set("custom_styles/panel", layer_buttons.get_child(0).get("custom_styles/panel").duplicate())
	layer_buttons.add_child_below_node(
			layer_buttons.get_child(layer_buttons.get_child_count() - 1), new_layer_button, true)
	_total_added_layers += 1
	new_layer_button.find_node("Select").text = "Layer " + str(_total_added_layers)
	_layer_button_ref[new_layer_button.name] = new_layer_button
	_connect_layer_buttons()
	
	var layer: GELayer = paint_canvas.add_new_layer(new_layer_button.name) 
	
	highlight_layer(paint_canvas.get_active_layer().name)
	#print("added layer: ", layer.name)
	return layer


func remove_active_layer():
	if layer_buttons.get_child_count() <= 1:
		return
	var layer_name = paint_canvas.active_layer.name
	paint_canvas.remove_layer(layer_name)
	layer_buttons.remove_child(_layer_button_ref[layer_name])
	_layer_button_ref[layer_name].queue_free()
	_layer_button_ref.erase(layer_name)
	
	highlight_layer(paint_canvas.get_active_layer().name)


func duplicate_active_layer():
	var new_layer_button = layer_buttons.get_child(0).duplicate()
	new_layer_button.set("custom_styles/panel", layer_buttons.get_child(0).get("custom_styles/panel").duplicate())
	layer_buttons.add_child_below_node(
			layer_buttons.get_child(layer_buttons.get_child_count() - 1), new_layer_button, true)
	
	_total_added_layers += 1 # for keeping track...
	new_layer_button.find_node("Select").text = "Layer " + str(_total_added_layers)
	
	var new_layer = paint_canvas.duplicate_layer(paint_canvas.active_layer.name, new_layer_button.name) 
	new_layer.update_texture()
	_layer_button_ref[new_layer.name] = new_layer_button
	
	new_layer_button.find_node("Select").connect("pressed", self, "select_layer", [new_layer_button.name])
	new_layer_button.find_node("Visible").connect("pressed", self, "toggle_layer_visibility", 
			[new_layer_button.find_node("Visible"), new_layer_button.name])
	new_layer_button.find_node("Up").connect("pressed", self, "move_down", [new_layer_button])
	new_layer_button.find_node("Down").connect("pressed", self, "move_up", [new_layer_button])
	new_layer_button.find_node("Lock").connect("pressed", self, "lock_layer", [new_layer_button, new_layer_button.name])
	
	# update highlight
	highlight_layer(paint_canvas.get_active_layer().name)
	#print("added layer: ", new_layer.name, " (total:", layer_buttons.get_child_count(), ")")


func move_up(layer_btn):
	var new_idx = min(layer_btn.get_index() + 1, layer_buttons.get_child_count())
	#print("move_up: ", layer_btn.name, " from ", layer_btn.get_index(), " to ", new_idx)
	layer_buttons.move_child(layer_btn, new_idx)
	paint_canvas.move_layer_back(layer_btn.name)


func move_down(layer_btn):
	var new_idx = max(layer_btn.get_index() - 1, 0)
	#print("move_down: ", layer_btn.name, " from ", layer_btn.get_index(), " to ", new_idx)
	layer_buttons.move_child(layer_btn, new_idx)
	paint_canvas.move_layer_forward(layer_btn.name)


func _connect_layer_buttons():
	for layer_btn in layer_buttons.get_children():
		if layer_btn.find_node("Select").is_connected("pressed", self, "select_layer"):
			continue
		layer_btn.find_node("Select").connect("pressed", self, "select_layer", [layer_btn.name])
		layer_btn.find_node("Visible").connect("pressed", self, "toggle_layer_visibility", 
				[layer_btn.find_node("Visible"), layer_btn.name])
		layer_btn.find_node("Up").connect("pressed", self, "move_down", [layer_btn])
		layer_btn.find_node("Down").connect("pressed", self, "move_up", [layer_btn])
		layer_btn.find_node("Lock").connect("pressed", self, "lock_layer", 
				[layer_btn, layer_btn.name])


func _on_Button_pressed():
	add_new_layer()


func _on_PaintCanvasContainer_mouse_entered():
	if mouse_on_top == true:
		return
	mouse_on_top = true
	paint_canvas.tool_layer.clear()
	paint_canvas.update()
	paint_canvas.tool_layer.update_texture()


func _on_PaintCanvasContainer_mouse_exited():
	if mouse_on_top == false:
		return
	mouse_on_top = false
	paint_canvas.tool_layer.clear()
	paint_canvas.update()
	paint_canvas.tool_layer.update_texture()


func _on_ColorPicker_popup_closed():
	find_node("Colors").add_color_prefab(find_node("ColorPicker").color)


############################################
# MISC
############################################

func is_position_in_canvas(pos):
	if Rect2(paint_canvas_container_node.rect_global_position, 
			 paint_canvas_container_node.rect_global_position + paint_canvas_container_node.rect_size).has_point(pos):
		return true
	return false


func is_mouse_in_canvas() -> bool:
	if is_position_in_canvas(get_global_mouse_position()):
		return true #mouse_on_top # check if mouse is inside canvas
	else:
		return false


func is_any_menu_open() -> bool:
	return $ChangeCanvasSize.visible or \
			$ChangeGridSizeDialog.visible or \
			$Settings.visible or \
			$LoadFileDialog.visible or \
			$SaveFileDialog.visible or \
			find_node("Navbar").is_any_menu_open()
	


func _on_LockAlpha_pressed():
	var checked = find_node("LockAlpha").pressed
	paint_canvas.active_layer.toggle_alpha_locked()
	for i in range(find_node("Layer").get_popup().get_item_count()):
		if find_node("Layer").get_popup().get_item_text(i) == "Toggle Alpha Locked":
			find_node("Layer").get_popup().set_item_checked(i, not find_node("Layer").get_popup().is_item_checked(i))


func _on_BrushRect_pressed():
	if brush_mode != Tools.BRUSH:
		set_brush(Tools.BRUSH)
	selected_brush_prefab = BrushPrefabs.Type.RECT


func _on_BrushCircle_pressed():
	if brush_mode != Tools.BRUSH:
		set_brush(Tools.BRUSH)
	selected_brush_prefab = BrushPrefabs.Type.CIRCLE


func _on_BrushVLine_pressed():
	if brush_mode != Tools.BRUSH:
		set_brush(Tools.BRUSH)
	selected_brush_prefab = BrushPrefabs.Type.V_LINE


func _on_BrushHLine_pressed():
	if brush_mode != Tools.BRUSH:
		set_brush(Tools.BRUSH)
	selected_brush_prefab = BrushPrefabs.Type.H_LINE


func _on_BrushSize_value_changed(value: float):
	find_node("BrushSizeLabel").text = str(int(value))


func _on_XSymmetry_pressed():
	paint_canvas.symmetry_x = not paint_canvas.symmetry_x


func _on_YSymmetry_pressed():
	paint_canvas.symmetry_y = not paint_canvas.symmetry_y
