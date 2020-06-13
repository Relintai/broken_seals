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

extends KinematicBody

export(float) var max_visible_distance : float = 120 setget set_max_visible_distance
var max_visible_distance_squared : float = max_visible_distance * max_visible_distance

export(float) var MOUSE_SENSITIVITY : float = 0.05
export(String) var world_path : String = "../.."
export(NodePath) var model_path : NodePath = "Rotation_Helper/Model"
export(NodePath) var character_skeleton_path : NodePath = "Rotation_Helper/Model/character"

const ray_length = 1000
const ACCEL : float = 100.0
const DEACCEL : float = 100.0
const GRAVITY : float = -24.8
const JUMP_SPEED : float = 3.8
const MAX_SLOPE_ANGLE : float = 40.0
const MOUSE_TARGET_MAX_OFFSET : int = 10

var _on : bool = true
var _controlled : bool = false

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
var target_movement_direction : Vector2 = Vector2()

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

var sleep : bool = false
var sleep_recheck_timer : float = 0
var dead : bool = false
var death_timer : float = 0

var last_mouse_over : Entity = null

var world : VoxelWorld = null

var entity : Entity
var model_rotation_node : Spatial
var character_skeleton : CharacterSkeleton3D 

var visibility_update_timer : float = 0
var placed : bool = false

func _ready() -> void:
	camera = get_node_or_null("CameraPivot/Camera") as Camera
	camera_pivot = get_node_or_null("CameraPivot") as Spatial
	
	model_rotation_node = get_node(model_path)
	character_skeleton = get_node(character_skeleton_path)
	entity = get_node("..")
	entity.set_character_skeleton(character_skeleton)
	entity.connect("notification_ccast", self, "on_notification_ccast")
	entity.connect("diesd", self, "on_diesd")
	entity.connect("isc_controlled_changed", self, "on_c_controlled_changed")
	owner = entity

	on_c_controlled_changed(entity.c_is_controlled)
	
	transform = entity.get_transform_3d(true)
	
	animation_tree = character_skeleton.get_animation_tree()
	
	if animation_tree != null:
		anim_node_state_machine = animation_tree["parameters/playback"]
		
	animation_tree["parameters/run-loop/blend_position"] = Vector2(0, -1)
	
#	set_process(false)
#	set_process_input(false)
#	set_process_unhandled_input(false)

func _enter_tree():
	world = get_node(world_path) as VoxelWorld
	
	set_physics_process(true)

func _process(delta : float) -> void:
	if entity.ai_state == EntityEnums.AI_STATE_OFF:
		return
		
	visibility_update_timer += delta
	
	if visibility_update_timer < 1:
		return
		
	visibility_update_timer = 0
	
	var camera : Camera = get_tree().get_root().get_camera() as Camera
	
	if camera == null:
		return
	
	var cam_pos : Vector3 = camera.global_transform.xform(Vector3())
	var dstv : Vector3 = cam_pos - translation
	dstv.y = 0
	var dst : float = dstv.length_squared()

	if dst > max_visible_distance_squared:
		if visible:
			hide()
		return
	else:
#		var lod_level : int = int(dst / max_visible_distance_squared * 3.0)

		if dst < 400: #20^2
			entity.get_character_skeleton().set_lod_level(0)
		elif dst > 400 and dst < 900: #20^2, 30^2
			entity.get_character_skeleton().set_lod_level(1)
		else:
			entity.get_character_skeleton().set_lod_level(2)
		
		if not visible:
			show()


func _physics_process(delta : float) -> void:
	if not _on:
		return
		
	if world.initial_generation:
		return
		
	if entity.sentity_data == null:
		return
		
	if dead:
		return
		
	if not placed:
		if world != null:
			if not world.is_position_walkable(transform.origin):
				return
			
			var space : PhysicsDirectSpaceState = get_world().direct_space_state
			
			var res : Dictionary = space.intersect_ray(transform.origin, transform.origin + Vector3(0, -100, 0), [ self ])

			if not res.empty():
				var pos : Vector3 = res["position"]
				transform.origin = pos + Vector3(0, 0.2, 0)
				
			placed = true
			return
		
	if entity.c_is_controlled:
		process_input(delta)
		process_movement_player(delta)
	else:
		if sleep:
			sleep_recheck_timer += delta
			
			if sleep_recheck_timer < 0.5:
				return
				
			sleep_recheck_timer = 0
		
		if world != null:
			if not world.is_position_walkable(transform.origin):
				return

		process_movement_mob(delta)

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
	
	var state : int = entity.getc_state()
	
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

func process_movement_player(delta : float) -> void:
	var state : int = entity.getc_state()
	
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
		entity.moved()
	else:
		dir = Vector3()
		moving = false

	vel.y += delta * GRAVITY

	var hvel : Vector3 = vel
	hvel.y = 0

	var target : Vector3 = dir
	target *= entity.getc_speed().current_value  / 100.0 * 4.2

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta) as Vector3
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0,1,0), true, 4, deg2rad(MAX_SLOPE_ANGLE))

	if multiplayer.has_network_peer():
		if not multiplayer.is_network_server():
			rpc_id(1, "sset_position", translation, rotation)
		else:
			sset_position(translation, rotation)
			

func process_movement_mob(delta : float) -> void:
	if entity.starget != null:
		look_at(entity.starget.get_body().translation, Vector3(0, 1, 0))
	
	var state : int = entity.getc_state()
	
	if state & EntityEnums.ENTITY_STATE_TYPE_FLAG_ROOT != 0 or state & EntityEnums.ENTITY_STATE_TYPE_FLAG_STUN != 0:
		moving = false
		return
	
	if target_movement_direction.length_squared() > 0.1:
		if anim_node_state_machine != null and not animation_run:
			anim_node_state_machine.travel("run-loop")
			animation_run = true
		
		target_movement_direction = target_movement_direction.normalized()
		moving = true
	else:
		if anim_node_state_machine != null and animation_run:
			anim_node_state_machine.travel("idle-loop")
			animation_run = false
			
		moving = false
	
	if target_movement_direction.x > 0.1 or target_movement_direction.y > 0.1 or target_movement_direction.x < -0.1 or target_movement_direction.y < -0.1:
		y_rot = Vector2(0, 1).angle_to(target_movement_direction)
		
		var forward : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), deg2rad(y_rot)) 
		var right : Vector3 = forward.cross(Vector3(0, 1, 0)) * -target_movement_direction.x
		forward *= target_movement_direction.y #only potentially make it zero after getting the right vector
	
		dir = forward
		dir += right
		
		if dir.length_squared() > 0.1:
			dir = dir.normalized()
			
		moving = true
	else:
		dir = Vector3()
		moving = false
		
	if not moving and sleep:
		return

	if moving and sleep:
		sleep = false

	vel.y += delta * GRAVITY

	var hvel : Vector3 = vel
	hvel.y = 0

	var target : Vector3 = dir
	target *= entity.getc_speed().current_value / 100.0 * 4.2

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta) as Vector3
	vel.x = hvel.x
	vel.z = hvel.z
	
	var facing : Vector3 = vel
	facing.y = 0
	
	vel = move_and_slide(vel, Vector3(0,1,0), false, 4, deg2rad(MAX_SLOPE_ANGLE))
	sset_position(translation, rotation)
	
	if vel.length_squared() < 0.12:
		sleep = true
	
	if translation.y < -50.0:
		print("killed mob with fall damage")
		var sdi : SpellDamageInfo = SpellDamageInfo.new()
		sdi.damage_source_type = SpellDamageInfo.DAMAGE_SOURCE_UNKNOWN
		sdi.damage = 999999999
		entity.stake_damage(sdi)


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
	
	rotation_degrees = Vector3(0.0, y_rot, 0.0)
	

func target(position : Vector2):
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
		
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], collision_mask)
		
	if result:
		if result.collider and result.collider.owner is Entity:
			var ent : Entity = result.collider.owner as Entity
			
			entity.target_crequest_change(ent.get_path())
			return

		entity.target_crequest_change(NodePath())
	else:
		entity.target_crequest_change(NodePath())
		
func cmouseover(event):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
		
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], collision_mask)
	
	if result:
		if result.collider:# and result.collider.owner is Entity:
			var mo : Entity = result.collider.owner as Entity
			
			if mo == null:
				return
			
			if last_mouse_over != null and last_mouse_over != mo:
				if is_instance_valid(last_mouse_over):
					last_mouse_over.notification_cmouse_exit()
					
				last_mouse_over = null
			
			if last_mouse_over == null:
				mo.notification_cmouse_enter()
				last_mouse_over = mo
			
			return
			
	if last_mouse_over != null:
		last_mouse_over.notification_cmouse_exit()
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
	if multiplayer.network_peer and multiplayer.is_network_server():
		entity.vrpc("cset_position", position, rotation)
		
		if _controlled:
			cset_position(position, rotation)
		
remote func cset_position(position : Vector3, rotation : Vector3) -> void:
	translation = position
	rotation = rotation
	

func on_notification_ccast(what : int, info : SpellCastInfo) -> void:
	if what == SpellEnums.NOTIFICATION_CAST_STARTED:
		if anim_node_state_machine != null and not casting_anim:
			anim_node_state_machine.travel("casting-loop")
			casting_anim = true
			animation_run = false
	elif what == SpellEnums.NOTIFICATION_CAST_FAILED:
		if anim_node_state_machine != null and casting_anim:
			anim_node_state_machine.travel("idle-loop")
			casting_anim = false
			
			if animation_run:
				anim_node_state_machine.travel("run-loop")
	elif what == SpellEnums.NOTIFICATION_CAST_FINISHED:
		if anim_node_state_machine != null:
			anim_node_state_machine.travel("cast-end")
			casting_anim = false
			
			if animation_run:
				anim_node_state_machine.travel("run-loop")
	elif what == SpellEnums.NOTIFICATION_CAST_SUCCESS:
		if anim_node_state_machine != null:
			anim_node_state_machine.travel("cast-end")
			casting_anim = false
			
			if animation_run:
				anim_node_state_machine.travel("run-loop")
	
	
func on_c_controlled_changed(val):
	#create camera and pivot if true
	_controlled = val
	
	if val:
		var cam_scene : PackedScene = ResourceLoader.load("res://player/camera/CameraPivot.tscn")
		camera_pivot = cam_scene.instance() as Spatial
		add_child(camera_pivot)
		camera = camera_pivot.get_node("Camera") as Camera
		
		var uiscn : PackedScene = ResourceLoader.load("res://ui/player_ui/player_ui.tscn")
		var ui = uiscn.instance()
		add_child(ui)
		
		
		set_process_input(true)
		set_process_unhandled_input(true)
	else:
		if camera_pivot:
			camera_pivot.queue_free()
			camera_pivot = null
			camera = null
			
		set_process_input(false)
		set_process_unhandled_input(false)
		var nameplatescn : PackedScene = ResourceLoader.load("res://ui/nameplates/NamePlate.tscn")
		var nameplate = nameplatescn.instance()
		add_child(nameplate)
		
		
 
func on_diesd(entity):
	if dead:
		return

	dead = true

	anim_node_state_machine.travel("dead")
	
	set_physics_process(false)
	
remote func set_position(position : Vector3, rotation : Vector3) -> void:
	if get_tree().is_network_server():
		rpc("set_position", position, rotation)

		
func set_max_visible_distance(var value : float) -> void:
	max_visible_distance_squared = value * value
	
	max_visible_distance = value

