extends Label

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var animation_player_path : NodePath = "AnimationPlayer"

export(Color) var damage_color : Color = Color.yellow
export(Color) var heal_color : Color = Color.green

var world_position : Vector3 = Vector3()
var animation_player : AnimationPlayer = null
var camera : Camera = null

func _ready() -> void:
	animation_player = get_node(animation_player_path) as AnimationPlayer
	
	animation_player.connect("animation_finished", self, "animation_finished")
	
	set_process(false)

func _process(delta):
	if camera == null:
		return
		
	var cam_pos : Vector3 = camera.global_transform.xform(Vector3())
	var dstv : Vector3 = cam_pos - world_position
	dstv.y = 0
#	var dst : float = dstv.length_squared()
		
	var cam_facing : Vector3 = -camera.global_transform.basis.z
	var d : float = cam_facing.dot(dstv)
		
	if d > 0:
		if visible:
			hide()
		return
	else:
		if not visible:
			show()
		
	var screen_position : Vector2 = camera.unproject_position(world_position)
	var new_pos : Vector2 = Vector2(screen_position.x + rect_position.x, screen_position.y + rect_position.y - 60)
	
	set_position(new_pos)
	

func damage(pos : Vector3, value : int, crit : bool) -> void:
	setup(pos, damage_color, value, crit)
	
func heal(pos : Vector3, value : int, crit : bool) -> void:
	setup(pos, heal_color, value, crit)

func setup(pos : Vector3, color : Color, value : int, crit : bool) -> void:
	world_position = pos
	
	camera = get_tree().get_root().get_camera() as Camera
	
	text = str(value)
	add_color_override("font_color", color)
	
	if crit:
		animation_player.play("crit")
	else:
		animation_player.play("normal")
		
	set_process(true)

func animation_finished(anim_name : String) -> void:
	queue_free()
