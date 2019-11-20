extends ScrollContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
	
	for i in range(spec.get_num_talent_rows()):
		var r : Node = talent_row_scene.instance()
		_container.add_child(r)
		r.owner = self
		r.set_player(player, spec, spec_index, i)
	
