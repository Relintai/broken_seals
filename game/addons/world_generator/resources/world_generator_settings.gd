tool
extends Resource
class_name WorldGeneratorSettings

export(PoolStringArray) var continent_class_folders : PoolStringArray
export(PoolStringArray) var zone_class_folders : PoolStringArray
export(PoolStringArray) var subzone_class_folders : PoolStringArray
export(PoolStringArray) var subzone_prop_class_folders : PoolStringArray

enum WorldGeneratorScriptType {
	CONTINENT = 0,
	ZONE = 1,
	SUBZONE = 2,
	SUBZONE_PROP = 3,
};

func evaluate_scripts(script_type : int, tree : Tree) -> void:
	if (script_type == WorldGeneratorScriptType.CONTINENT):
		evaluate_continent_scripts(tree)
	elif (script_type == WorldGeneratorScriptType.ZONE):
		evaluate_zone_scripts(tree)
	elif (script_type == WorldGeneratorScriptType.SUBZONE):
		evaluate_subzone_scripts(tree)
	elif (script_type == WorldGeneratorScriptType.SUBZONE_PROP):
		evaluate_subzone_prop_scripts(tree)

func evaluate_continent_scripts(tree : Tree) -> void:
	tree.clear()
	
	var root : TreeItem = tree.create_item()
	root.set_text(0, "Continent")
	root.set_meta("class_name", "Continent")
	
	for s in continent_class_folders:
		evaluate_folder(s, tree, root)
		
	root.select(0)

func evaluate_zone_scripts(tree : Tree) -> void:
	tree.clear()
	
	var root : TreeItem = tree.create_item()
	root.set_text(0, "Zone")
	root.set_meta("class_name", "Zone")
	
	for s in zone_class_folders:
		evaluate_folder(s, tree, root)
		
	root.select(0)
	
func evaluate_subzone_scripts(tree : Tree) -> void:
	tree.clear()
	
	var root : TreeItem = tree.create_item()
	root.set_text(0, "SubZone")
	root.set_meta("class_name", "SubZone")
	
	for s in subzone_class_folders:
		evaluate_folder(s, tree, root)
		
	root.select(0)

func evaluate_subzone_prop_scripts(tree : Tree) -> void:
	tree.clear()
	
	var root : TreeItem = tree.create_item()
	root.set_text(0, "SubZoneProp")
	root.set_meta("class_name", "SubZoneProp")
	
	for s in subzone_prop_class_folders:
		evaluate_folder(s, tree, root)
		
	root.select(0)

func evaluate_folder(folder : String, tree : Tree, root : TreeItem) -> void:
	var ti : TreeItem = null
	
	var dir = Directory.new()
	if dir.open(folder) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				#print("Found file: " + file_name)
				
				if !ti:
					var n : String = folder.substr(folder.find_last("/") + 1)
					
					if n != "":
						ti = tree.create_item(root)
						ti.set_text(0, n)
					else:
						ti = root
				
				var e : TreeItem = tree.create_item(ti)
				
				e.set_text(0, file_name.get_file())
				e.set_meta("file", folder + "/" + file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


