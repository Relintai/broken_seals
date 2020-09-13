extends EntityData
class_name EntityDataGD

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

func _sinteract(entity: Entity) -> void:
	var target : Entity = entity.gets_target()
	
	if target == null or not is_instance_valid(target):
		return
		
	if target.sentity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_LOOT:
		if target.gets_entity_data().loot_db != null and target.sbag == null:
			var ldb : LootDataBase = target.gets_entity_data().loot_db
			
			var loot : Array = Array()
			
			ldb.get_loot()
			
			var bag : Bag = Bag.new()
			bag.set_size(loot.size())
			
			for item in loot:
				var it : ItemTemplate = item as ItemTemplate
				
				bag.add_item(it.create_item_instance())
				
			target.sbag = bag
		
		entity.starget_bag = target.sbag
			
		entity.ssend_open_window(EntityEnums.ENTITY_WINDOW_LOOT)
	elif target.sentity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_TRAIN:
		entity.ssend_open_window(EntityEnums.ENTITY_WINDOW_TRAINER)
	elif target.sentity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_VENDOR:
		entity.ssend_open_window(EntityEnums.ENTITY_WINDOW_VENDOR)

func _cans_interact(entity):
	var target : Entity = entity.gets_target()
	
	if target == null or not is_instance_valid(target):
		return false
	
	return true
