extends Resource
class_name GameModule

export(ESSResourceDB) var resource_db : ESSResourceDB

func load_module():
	if resource_db != null:
		resource_db.initialize()

		ESS.resource_db.add_entity_resource_db(resource_db)
		
#		var r : ESSResourceDB = ESS.resource_db
