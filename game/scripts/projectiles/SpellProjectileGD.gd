extends SpellProjectile
class_name SpellProjectileGD

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var _target : Spatial
var _info : SpellCastInfo
var _speed : float

func _ready() -> void:
	if _info == null:
		set_process(false)

func launch(info : SpellCastInfo, effect : PackedScene, speed : float) -> void:
	if not is_instance_valid(info.target):
		return
	
	_info = info
	_target = info.target.get_character_skeleton().torso_attach_point
	_speed = speed
	
#	translation = info.caster.translation
	translation = info.caster.get_character_skeleton().right_hand_attach_point.global_transform.origin
	
	var eff : Node = effect.instance()
	
	eff.owner = self
	add_child(eff)

	set_process(true)

func _process(delta : float) -> void:
	if not is_instance_valid(_target):
#		set_process(false)
		queue_free()
		return
		
	var l : Vector3 =  _target.global_transform.origin - translation
		
	if l.length() < 1:
		_info.spell.son_spell_hit(_info)
		queue_free()
		return
		
	var dir : Vector3 = l.normalized()

	global_transform.origin += dir * _speed * delta
	global_transform  = transform.looking_at(_target.global_transform.origin, Vector3(0, 1, 0))
	
