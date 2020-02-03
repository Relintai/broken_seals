extends "PlayerGDBase.gd"
class_name PlayerGD

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019-2020 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(float) var MOUSE_SENSITIVITY : float = 0.05
export(String) var world_path : String = ".."
export(NodePath) var model_path : NodePath = "Rotation_Helper/Model"

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

var world : VoxelWorld = null

var model_rotation_node : Spatial

func _ready() -> void:
	camera = $Body/CameraPivot/Camera as Camera
	camera_pivot = $Body/CameraPivot as Spatial
	
	model_rotation_node = get_node(model_path)

	animation_tree = get_character_skeleton().get_animation_tree()
	
	if animation_tree != null:
		anim_node_state_machine = animation_tree["parameters/playback"]
		
	set_physics_process(false)

func _enter_tree():
	world = get_node(world_path) as VoxelWorld
	set_physics_process(true)

func _physics_process(delta : float) -> void:
	if not _on:
		return
		
	if world.initial_generation:
		return
	
	process_input(delta)
	process_movement(delta)

func process_input(delta: float) -> void:
	var key_dir : Vector2 = Vector2()
	
	if key_up:
		key_dir.y -= 1
	if key_down:
		key_dir.y += 1
	if key_left:
		key_dir.x -= 1
	if key_right:
		key_dir.x += 1
		
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
		
		if (input_dir.y < 0.1):
			model_rotation_node.transform.basis = Basis(Vector3(0, acos(input_dir.x) - PI / 2.0, 0))
		else:
			model_rotation_node.transform.basis = Basis()
	else:
		if anim_node_state_machine != null and animation_run:
			anim_node_state_machine.travel("idle-loop")
			animation_run = false
			
	if queued_camera_rotaions.length_squared() > 1:
		camera_pivot.rotate_delta(queued_camera_rotaions.x * 2.0, queued_camera_rotaions.y)
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
	vel = get_body().move_and_slide(vel, Vector3(0,1,0), true, 4, deg2rad(MAX_SLOPE_ANGLE))

	if multiplayer.has_network_peer():
		if not multiplayer.is_network_server():
			rpc_id(1, "sset_position", get_body().translation, get_body().rotation)
		else:
			sset_position(get_body().translation, get_body().rotation)


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
				camera_pivot.rotate_delta(0.0, -event.relative.y)
				rotate_delta(-event.relative.x)
			else:
				camera_pivot.rotate_delta(-relx, -rely)

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
			mouse_move_dir.y = -1
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
	
	get_body().rotation_degrees = Vector3(0.0, y_rot, 0.0)
	
func target(position : Vector2):
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
		
	var space_state = get_body().get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], get_body().collision_mask)
		
	if result:
		if result.collider and result.collider.owner is Entity:
			var ent : Entity = result.collider.owner as Entity
			
			crequest_target_change(ent.get_path())
			return

		crequest_target_change(NodePath())
	else:
		crequest_target_change(NodePath())
		
func cmouseover(event):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
		
	var space_state = get_body().get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], get_body().collision_mask)
	
	if result:
		if result.collider:# and result.collider.owner is Entity:
			var mo : Entity = result.collider.owner as Entity
			
			if mo == null:
				return
			
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
		touchpad_dir.y *= -1
	elif touchpad.padname == "TargetPad":
		#try to target
		return
		
func queue_camera_rotation(rot : Vector2) -> void:
	queued_camera_rotaions += rot

remote func sset_position(position : Vector3, rotation : Vector3) -> void:
	if get_network_master() != 1:
		print(str(get_network_master()) + "psset")
	
	if multiplayer.network_peer and multiplayer.is_network_server():
		vrpc("cset_position", position, rotation)
		cset_position(position, rotation)
		
remote func cset_position(position : Vector3, rotation : Vector3) -> void:
	if get_network_master() != 1:
		print(str(get_network_master()) + " pcset")
	get_body().translation = position
	get_body().rotation = rotation
		
#func _setup():
#	setup_actionbars()

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
	
func _from_dict(dict):
	._from_dict(dict)
	
	randomize()
	sseed = randi()
	
