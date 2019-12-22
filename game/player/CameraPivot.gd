extends Spatial

# Copyright (c) 2019 Péter Magyar
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

export (float) var max_camera_distance : float = 20.0

var target_camera_distance : float = 6.0
var camera_distance : float = target_camera_distance

var camera : Camera

var x_rot : float = 0.0
var y_rot : float = 0.0

var player : Entity

func _ready() -> void:
	camera = $Camera

	camera.translation.z = target_camera_distance
	
	player = get_node("..")
	
	set_physics_process(true)
	
func _physics_process(delta):
	var pos : Vector3 = to_global(Vector3())
	
	var space_state = get_world().direct_space_state
	
	var result : Dictionary = space_state.intersect_ray(pos, to_global(Vector3(0, 0, target_camera_distance)), [player], player.collision_mask)
	
	if result:
		camera_distance = (result.position - pos).length() - 0.2
	else:
		camera_distance = target_camera_distance
		
	camera.translation.z = camera_distance

func camera_distance_set_delta(delta : float) -> void:
	target_camera_distance += delta
	
	if target_camera_distance > max_camera_distance:
		target_camera_distance = max_camera_distance
	elif target_camera_distance < 0:
		target_camera_distance = 0

func rotate_delta(x_delta : float, y_delta : float) -> void:
	x_rot += y_delta
	y_rot += x_delta
	
	x_rot = clamp(x_rot, -90, 90)
	
	if y_rot >= 360:
		y_rot = y_rot - 360
	if y_rot < 0:
		y_rot = y_rot + 360
	
	rotation_degrees = Vector3(x_rot, y_rot, 0.0)

func get_y_rot() -> float:
	return y_rot

func set_y_rot(yrot : float) -> void:
	y_rot =  yrot
	
	rotation_degrees = Vector3(x_rot, y_rot, 0.0)

func a_process(delta : float) -> void:
	y_rot += delta
	
	rotation_degrees = Vector3(x_rot, y_rot, 0.0)
