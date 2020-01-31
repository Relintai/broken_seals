extends WorldSpell
class_name WorldSpellGD

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
	get_body().translation = info.caster.get_character_skeleton().right_hand_attach_point.global_transform.origin
	
	var eff : Node = effect.instance()
	
	eff.owner = self
	add_child(eff)

	set_process(true)

func _process(delta : float) -> void:
	if not is_instance_valid(_target):
#		set_process(false)
		queue_free()
		return
		
	var l : Vector3 =  _target.global_transform.origin - get_body().translation
		
	if l.length() < 1:
		_info.spell.son_spell_hit(_info)
		queue_free()
		return
		
	var dir : Vector3 = l.normalized()

	get_body().global_transform.origin += dir * _speed * delta
	get_body().global_transform  = get_body().transform.looking_at(_target.global_transform.origin, Vector3(0, 1, 0))
	
