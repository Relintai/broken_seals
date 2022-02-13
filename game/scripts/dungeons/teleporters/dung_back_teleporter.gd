extends StaticBody

export(Material) var default_material : Material = null
export(Material) var hover_material : Material = null
export(float) var use_range : float = 5

var _dungeon : Spatial = null

var teleport_to : Vector3 = Vector3()

var _is_windows : bool = false
var _mouse_hover : bool = false

func _ready():
	_is_windows = OS.get_name() == "Windows"
	
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	
	if default_material:
		$MeshDataInstance.material = default_material
	
func on_mouse_entered():
	if hover_material:
		$MeshDataInstance.material = hover_material
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
	_mouse_hover = true

func on_mouse_exited():
	if default_material:
		$MeshDataInstance.material = default_material
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	_mouse_hover = false

#func _enter_tree():
#	if get_parent().has_method("get_voxel_scale"):
#

func _exit_tree():
	if _dungeon:
		_dungeon.queue_free()

# workaround
func _unhandled_input(event):
	# _input_event does not get InputEventMouseButtons (on wine) / it only gets them sometimes (on windows)
	# might be an engine bug
	if _is_windows && _mouse_hover && event is InputEventMouseButton && !event.pressed:
		teleport()

func _input_event(camera: Object, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int):
	if !_is_windows && event is InputEventMouseButton && !event.pressed:
		teleport()
	
	if event is InputEventScreenTouch && !event.pressed:
		teleport()

func teleport():
	var world = get_node("..")
	
	if world && world._player:
		var p : Entity = world._player

		if (p.get_body().transform.origin - transform.origin).length() > use_range:
			return

		if _dungeon:
			#turn it off
			_dungeon.hide()
		
		#turn back on world
		world.active = true
		
		p.get_body().teleport(teleport_to)
#		p.get_body().transform.origin = teleport_to
