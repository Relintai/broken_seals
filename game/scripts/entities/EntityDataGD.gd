extends EntityData
class_name EntityDataGD

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

func _sinteract(entity: Entity) -> void:
	var target : Entity = entity.gets_target()
	
	if target == null or not is_instance_valid(target):
		return
		
	if target.sentity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_LOOT:
		if target.gets_entity_data().loot_db != null and target.sbag == null:
			var ldb : LootDataBase = target.gets_entity_data().loot_db
			
			var loot : Array = Array()
			
			ldb.get_loot(loot)
			
			var bag : Bag = Bag.new()
			bag.set_size(loot.size())
			
			for item in loot:
				var it : ItemTemplate = item as ItemTemplate
				
				bag.add_item(it.create_item_instance())
				
			target.sbag = bag
		
		entity.starget_bag = target.sbag
			
		entity.ssend_open_window(EntityEnums.ENTITY_WINDOW_LOOT)

func _cans_interact(entity):
	var target : Entity = entity.gets_target()
	
	if target == null or not is_instance_valid(target):
		return false
	
	return true
