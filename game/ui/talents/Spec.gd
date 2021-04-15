extends ScrollContainer

# Copyright (c) 2019-2021 Péter Magyar
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

export(PackedScene) var talent_row_scene : PackedScene
export(NodePath) var container_path : NodePath

var _container : Node

var _player : Entity
var _spec : CharacterSpec
var _spec_index : int

func _ready() -> void:
	_container = get_node(container_path)

func set_spec(player : Entity, spec : CharacterSpec, spec_index: int) -> void:
	for ch in _container.get_children():
		ch.queue_free()
	
	_player = player
	_spec = spec
	_spec_index = spec_index
	
	if _player == null or _spec == null:
		return
	
	for i in range(spec.num_rows):
		var r : Node = talent_row_scene.instance()
		_container.add_child(r)
		r.owner = self
		r.set_player(player, spec, spec_index, i)
	
