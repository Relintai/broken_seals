extends Entity

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (float) var MOUSE_SENSITIVITY : float = 0.05
export (String) var map_path : String

const ray_length = 1000
const ACCEL : float = 100.0
const DEACCEL : float = 100.0
const GRAVITY : float = -24.8
const JUMP_SPEED : float = 3.8
const MAX_SLOPE_ANGLE : float = 40.0
const MOUSE_TARGET_MAX_OFFSET : int = 10

var _on : bool = true

var y_rot : float = 0.0

var vel : Vector3 = Vector3()
var dir : Vector3 = Vector3()

var input_dir : Vector2 = Vector2()
var mouse_dir : Vector2 = Vector2()
var mouse_move_dir : Vector2 = Vector2()
var mouse_left_down : bool = false
var mouse_right_down : bool = false
var touchpad_dir : Vector2 = Vector2()
var mouse_down_delta : Vector2 = Vector2()
var queued_camera_rotaions : Vector2 = Vector2()

var key_left : bool = false
var key_right : bool = false
var key_up : bool = false
var key_down : bool = false

var cursor_grabbed : bool = false
var last_cursor_pos : Vector2 = Vector2()
var mouse_down_pos : Vector2 = Vector2()
var total_down_mouse_delta : Vector2 = Vector2()

var camera : Camera
var camera_pivot : Spatial

var animation_tree : AnimationTree
var anim_node_state_machine : AnimationNodeStateMachinePlayback = null
var animation_run : bool = false

var moving : bool = false
var casting_anim : bool = false

var last_mouse_over : Entity = null

func _ready() -> void:
	camera = $CameraPivot/Camera as Camera
	camera_pivot = $CameraPivot as Spatial

	animation_tree = get_character_skeleton().get_animation_tree()
	
	if animation_tree != null:
		anim_node_state_machine = animation_tree["parameters/playback"]

	set_process(true)

func _physics_process(delta : float) -> void:
	if not _on:
		return
	
	process_input(delta)
	process_movement(delta)

func process_input(delta: float) -> void:
	var key_dir : Vector2 = Vector2()
	
	if key_up:
		key_dir.y += 1
	if key_down:
		key_dir.y -= 1
	if key_left:
		key_dir.x += 1
	if key_right:
		key_dir.x -= 1
		
	input_dir = key_dir + mouse_dir + touchpad_dir + mouse_move_dir
	
	var state : int = getc_state()
	
	if state & EntityEnums.ENTITY_STATE_TYPE_FLAG_ROOT != 0 or state & EntityEnums.ENTITY_STATE_TYPE_FLAG_STUN != 0:
		input_dir = Vector2()
		return
	
	var input_length : float = input_dir.length_squared()
	
	if input_length > 0.1:
		if anim_node_state_machine != null and not animation_run:
			anim_node_state_machine.travel("run-loop")
			animation_run = true
			
		input_dir = input_dir.normalized()
		
		animation_tree["parameters/run-loop/blend_position"] = input_dir
	else:
		if anim_node_state_machine != null and animation_run:
			anim_node_state_machine.travel("idle-loop")
			animation_run = false
			
	if queued_camera_rotaions.length_squared() > 1:
		camera_pivot.rotate_delta(queued_camera_rotaions.x * 2.0, -queued_camera_rotaions.y)
		queued_camera_rotaions = Vector2()
		
		if input_length > 0.1:
			rotate_delta(camera_pivot.get_y_rot())
			camera_pivot.set_y_rot(0.0)

func process_movement(delta : float) -> void:
	var state : int = getc_state()
	
	if state & EntityEnums.ENTITY_STATE_TYPE_FLAG_ROOT != 0 or state & EntityEnums.ENTITY_STATE_TYPE_FLAG_STUN != 0:
		moving = false
		return
	
	if input_dir.x > 0.1 or input_dir.y > 0.1 or input_dir.x < -0.1 or input_dir.y < -0.1:
		var forward : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), deg2rad(y_rot)) 
		var right : Vector3 = forward.cross(Vector3(0, 1, 0)) * -input_dir.x
		forward *= input_dir.y #only potentially make it zero after getting the right vector
	
		dir = forward
		dir += right
		
		if dir.length_squared() > 0.1:
			dir = dir.normalized()
			
		moving = true
		moved()
	else:
		dir = Vector3()
		moving = false

	vel.y += delta * GRAVITY

	var hvel : Vector3 = vel
	hvel.y = 0

	var target : Vector3 = dir
	target *= get_speed().ccurrent

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta) as Vector3
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0,1,0), false, 4, deg2rad(MAX_SLOPE_ANGLE))
	
	if get_tree().network_peer:
		if get_tree().is_network_server():
			set_position(translation, rotation)
		else:
			rpc("set_position", translation, rotation)

func _input(event: InputEvent) -> void:
	if not cursor_grabbed:
		set_process_input(false)
		return
	
	if event is InputEventMouseMotion and event.device != -1:
		var s : float = ProjectSettings.get("display/mouse_cursor/sensitivity")
		
		var relx : float = event.relative.x * s
		var rely : float = event.relative.y * s
		
		mouse_down_delta.x += relx
		mouse_down_delta.y += rely
			
		total_down_mouse_delta.x += relx
		total_down_mouse_delta.y += rely
		
		get_tree().set_input_as_handled()
		
		if (mouse_right_down or mouse_left_down) and event.device != -1:
			if mouse_right_down:
				camera_pivot.rotate_delta(0.0, event.relative.y)
				rotate_delta(-event.relative.x)
			else:
				camera_pivot.rotate_delta(-relx, rely)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ievkey : InputEventKey = event as InputEventKey
		
		if ievkey.scancode == KEY_W:
			key_up = ievkey.pressed
		if ievkey.scancode == KEY_S:
			key_down = ievkey.pressed
		if ievkey.scancode == KEY_A:
			key_left = ievkey.pressed
		if ievkey.scancode == KEY_D:
			key_right = ievkey.pressed
			
	if event is InputEventMouseMotion and not (mouse_right_down or mouse_left_down) and event.device != -1:
		cmouseover(event)

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.device != -1:
			mouse_left_down = event.pressed
			
			if mouse_left_down:
				mouse_down_delta = Vector2()
				mouse_down_pos = event.position
		
		if event.button_index == BUTTON_RIGHT and event.device != -1:
			mouse_right_down = event.pressed
			
			if mouse_right_down:
				rotate_delta(camera_pivot.get_y_rot())
				camera_pivot.set_y_rot(0.0)
			
		if mouse_left_down and mouse_right_down:
			mouse_move_dir.y = 1
		else:
			mouse_move_dir.y = 0
			
		if event.is_pressed() and event.device != -1:
			if event.button_index == BUTTON_WHEEL_UP:
				camera_pivot.camera_distance_set_delta(-0.2)
			if event.button_index == BUTTON_WHEEL_DOWN:
				camera_pivot.camera_distance_set_delta(0.2)
		
		if not event.pressed and event.button_index == BUTTON_LEFT and event.device != -1:
			if mouse_down_delta.length() < MOUSE_TARGET_MAX_OFFSET:
				target(event.position)
			
	if event is InputEventScreenTouch and event.pressed:
		target(event.position)
			
	update_cursor_mode()
			
func update_cursor_mode():
	if mouse_left_down or mouse_right_down:
		if not cursor_grabbed:
			set_process_input(true)
			total_down_mouse_delta = Vector2()
			
			cursor_grabbed = true
			last_cursor_pos = get_viewport().get_mouse_position()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if cursor_grabbed:
			set_process_input(false)
			cursor_grabbed = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_viewport().warp_mouse(last_cursor_pos)
			
			if total_down_mouse_delta.length_squared() < 8:
				target(last_cursor_pos)
			
			
func rotate_delta(x_delta : float) -> void:
	y_rot += x_delta
	
	while y_rot > 360:
		y_rot -= 360
	
	while y_rot < 0:
		y_rot += 360
	
	rotation_degrees = Vector3(0.0, y_rot, 0.0)
	
func target(position : Vector2):
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
		
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 2)
		
	if result:
		print(result)
		if result.collider and result.collider is Entity:
			var ent : Entity = result.collider as Entity
			
			crequest_target_change(ent.get_path())
			return

		crequest_target_change(NodePath())
	else:
		crequest_target_change(NodePath())
		
func cmouseover(event):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
		
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 2)
	
	if result:
		if result.collider and result.collider is Entity:
			var mo : Entity = result.collider as Entity
			
			if last_mouse_over != null and last_mouse_over != mo:
				if is_instance_valid(last_mouse_over):
					last_mouse_over.onc_mouse_exit()
					
				last_mouse_over = null
			
			if last_mouse_over == null:
				mo.onc_mouse_enter()
				last_mouse_over = mo
			
			return
			
	if last_mouse_over != null:
		last_mouse_over.onc_mouse_exit()
		last_mouse_over = null
	
func analog_force_change(vector, touchpad):
	if touchpad.padname == "TouchPad":
		touchpad_dir = vector
		touchpad_dir.x *= -1
	elif touchpad.padname == "TargetPad":
		#try to target
		return
		
func queue_camera_rotation(rot : Vector2) -> void:
	queued_camera_rotaions += rot

remote func set_position(position : Vector3, rotation : Vector3) -> void:
	if get_tree().is_network_server():
		rpc("set_position", position, rotation)
		
func _moved() -> void:
	if sis_casting():
		sfail_cast()
		
func _con_target_changed(entity: Entity, old_target: Entity) -> void:
	if is_instance_valid(old_target):
		old_target.onc_untargeted()
		
	if is_instance_valid(ctarget):
		ctarget.onc_targeted()
		
		if canc_interact():
			crequest_interact()
		
func _con_cast_started(info):
	if anim_node_state_machine != null and not casting_anim:
		anim_node_state_machine.travel("casting-loop")
		casting_anim = true
		animation_run = false
		
func _con_cast_failed(info):
	if anim_node_state_machine != null and casting_anim:
		anim_node_state_machine.travel("idle-loop")
		casting_anim = false
		
		if animation_run:
			anim_node_state_machine.travel("run-loop")

func _con_cast_finished(info):
	if anim_node_state_machine != null:
		anim_node_state_machine.travel("cast-end")
		casting_anim = false
		
		if animation_run:
			anim_node_state_machine.travel("run-loop")
			
func _con_spell_cast_success(info):
	if anim_node_state_machine != null:
		anim_node_state_machine.travel("cast-end")
		casting_anim = false
		
		if animation_run:
			anim_node_state_machine.travel("run-loop")


