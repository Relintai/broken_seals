extends Entity
class_name DisplayPlayerGD

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019 Péter Magyar

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

func _setup():
	setup_actionbars()
	
	
func _son_level_up(level: int) -> void:
	if sentity_data == null:
		return
	
	var ecd : EntityClassData = sentity_data.entity_class_data
	
	if ecd == null:
		return
	
	sfree_spell_points += ecd.spell_points_per_level * level
	sfree_talent_points += level
	
	for i in range(Stat.MAIN_STAT_ID_COUNT):
		var st : int = sentity_data.entity_class_data.get_stat_data().get_level_stat_data().get_stat_diff(i, slevel - level, slevel)

		var statid : int = i + Stat.MAIN_STAT_ID_START
		
		var stat : Stat = get_stat_int(statid)
		
		var sm : StatModifier = stat.get_modifier(0)
		sm.base_mod += st
		

