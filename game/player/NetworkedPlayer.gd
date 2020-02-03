extends "PlayerGDBase.gd"
class_name NetworkedPlayerGD

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

const ray_length = 1000
const ACCEL : float = 100.0
const DEACCEL : float = 100.0
const GRAVITY : float = -24.8
const JUMP_SPEED : float = 3.8
const MAX_SLOPE_ANGLE : float = 40.0
const MOUSE_TARGET_MAX_OFFSET : int = 10

var y_rot : float = 0.0

var animation_tree : AnimationTree
var anim_node_state_machine : AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	animation_tree = get_character_skeleton().get_animation_tree()
	
	if animation_tree != null:
		anim_node_state_machine = animation_tree["parameters/playback"]
	

func rotate_delta(x_delta : float) -> void:
	y_rot += x_delta
	
	if y_rot > 360:
		y_rot = 0
	if y_rot < 0:
		y_rot = 360
	
	get_body().rotation_degrees = Vector3(0.0, y_rot, 0.0)

remote func sset_position(position : Vector3, rotation : Vector3) -> void:
	if multiplayer.network_peer and multiplayer.is_network_server():
		cset_position(position, rotation)
		vrpc("cset_position", position, rotation)
		
remote func cset_position(position : Vector3, rotation : Vector3) -> void:
	get_body().translation = position
	get_body().rotation = rotation
		
func _moved() -> void:
	if sis_casting():
		sfail_cast()
	
