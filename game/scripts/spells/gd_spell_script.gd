extends Spell
class_name SpellGD

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

func add_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().left_hand_attach_point.add_effect(basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().right_hand_attach_point.add_effect(basic_spell_effect.spell_cast_effect_right_hand)
		
func remove_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().left_hand_attach_point.remove_effect(basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().right_hand_attach_point.remove_effect(basic_spell_effect.spell_cast_effect_right_hand)
		
func _con_spell_cast_started(info):
	add_spell_cast_effect(info)

func _con_spell_cast_failed(info):
	remove_spell_cast_effect(info)
	
func _con_spell_cast_interrupted(info):
	remove_spell_cast_effect(info)
	
func _con_spell_cast_success(info):
	remove_spell_cast_effect(info)
	
	if not is_instance_valid(info.target):
		return
	
	var bse : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if bse != null:
		if bse.torso_spell_cast_finish_effect != null:
			info.target.get_character_skeleton().torso_attach_point.add_effect_timed(bse.torso_spell_cast_finish_effect, bse.torso_spell_cast_finish_effect_time)

		if bse.root_spell_cast_finish_effect != null:
			info.target.get_character_skeleton().root_attach_point.add_effect_timed(bse.root_spell_cast_finish_effect, bse.root_spell_cast_finish_effect_time)
			
