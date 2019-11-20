extends Camera

const SPEED = 10
const TURN_SENSITIVITY = 0.15

var x_rot : float = 0.0
var y_rot : float = 0.0

var mouse_right_down : bool = false

var input_dir : Vector2 = Vector2()

var key_left : bool = false
var key_right : bool = false
var key_up : bool = false
var key_down : bool = false

var cursor_grabbed : bool = false
var last_cursor_pos : Vector2 = Vector2()

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta: float) -> void:
	var key_dir = Vector2()
	
	if key_up:
		key_dir.y -= 1
	if key_down:
		key_dir.y += 1
	if key_left:
		key_dir.x -= 1
	if key_right:
		key_dir.x += 1
		
	input_dir = key_dir

	if input_dir.length_squared() > 0.1:
		input_dir = input_dir.normalized()
	
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.device != -1:
		mouse_right_down = event.pressed
		
	if event is InputEventKey:
		if event.scancode == KEY_W:
			key_up = event.pressed
		if event.scancode == KEY_S:
			key_down = event.pressed
		if event.scancode == KEY_A:
			key_left = event.pressed
		if event.scancode == KEY_D:
			key_right = event.pressed
			
	if event is InputEventMouseMotion and mouse_right_down and event.device != -1:
		rotate_delta(-event.relative.x, -event.relative.y)
			
	update_cursor_mode()
		
func process_movement(delta):
	if input_dir.x > 0.1 or input_dir.y > 0.1 or input_dir.x < -0.1 or input_dir.y < -0.1:
		var forward = transform.basis.xform(Vector3(0, 0, 1))
		
		var right = forward.cross(Vector3(0, 1, 0)) * -input_dir.x
		forward *= input_dir.y #only potentially make it zero after getting the right vector
	
		var dir : Vector3 = forward
		dir += right
		
		if dir.length_squared() > 0.1:
			dir = dir.normalized()
			translation += dir * delta * SPEED

func update_cursor_mode():
	if mouse_right_down:
		if not cursor_grabbed:
			cursor_grabbed = true
			last_cursor_pos = get_viewport().get_mouse_position()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if cursor_grabbed:
			cursor_grabbed = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_viewport().warp_mouse(last_cursor_pos)
			
func rotate_delta(x_delta : float, y_delta : float) -> void:
	x_rot += y_delta * TURN_SENSITIVITY
	y_rot += x_delta * TURN_SENSITIVITY
	
	x_rot = clamp(x_rot, -90, 90)
	
	if y_rot >= 360:
		y_rot = 0
	if y_rot < 0:
		y_rot = 360
	
	rotation_degrees = Vector3(x_rot, y_rot, 0.0)
