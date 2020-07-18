extends StaticBody

export(Color) var default_albedo : Color = Color(0.494118, 0.494118, 0.494118)
export(Color) var hover_albedo : Color = Color(0.65098, 0.65098, 0.65098)

var teleport_to : Vector3 = Vector3()

func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = default_albedo
	
func on_mouse_entered():
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = hover_albedo
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func on_mouse_exited():
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = default_albedo
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(camera: Object, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton && !event.pressed:
		teleport()
	
	if event is InputEventScreenTouch && !event.pressed:
		teleport()

func teleport():
	var world = get_node("..")
	
	if world && world._player:
		var p : Entity = world._player
		
		p.get_body().transform.origin = teleport_to
