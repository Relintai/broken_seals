extends Resource
class_name GameModule

export(bool) var enabled : bool = true

export(ESSResourceDB) var resource_db : ESSResourceDB

func load_module():
	if resource_db != null:
		resource_db.initialize()

		ESS.resource_db.add_entity_resource_db(resource_db)
		
#		var r : ESSResourceDB = ESS.resource_db
#
#		for e in r.get_entity_datas():
#			print(e.resource_path)
#			print(e.get_id())

#		for s in r.get_spells():
#			print(s.resource_name)
#			print(s.get_id())

func on_request_instance(what : int, node : Node) -> void:
	return
