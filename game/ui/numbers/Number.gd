extends Label

# Copyright (c) 2019-2020 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
