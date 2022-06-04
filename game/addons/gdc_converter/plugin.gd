tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Convert Scripts to Cpp", self, "on_convert_script_menu_clicked")
	add_tool_menu_item("Generate Cpp Class Bind for Scripts", self, "on_generate_class_binds_menu_clicked")
	add_tool_menu_item("Convert Scenes to Cpp", self, "on_convert_scene_menu_clicked")

func _exit_tree():
	remove_tool_menu_item("Convert Scripts to Cpp")
	remove_tool_menu_item("Generate Cpp Class Bind for Scripts")
	remove_tool_menu_item("Convert Scenes to Cpp")

func on_convert_script_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdsparser.gd")
	var parser = GDSParser.new()
	
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "gd":
					parser.process_file(dir_name + file_name)
			
			file_name = dir.get_next()

func on_generate_class_binds_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdc_class_bind_generator.gd")
	var parser = GDSParser.new()
	
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "gd":
					parser.process_file(dir_name + file_name)
			
			file_name = dir.get_next()

func on_convert_scene_menu_clicked(val) -> void:
	#var GDSParser = load("res://addons/gdc_converter/gdsparser.gd")
	#var parser = GDSParser.new()
	
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "tscn":
					process_file(dir_name + file_name)
			
			file_name = dir.get_next()

class GDSSceneParser:
	var result : String

	func parse(file_name : String) -> void:
		var ps : PackedScene = ResourceLoader.load(file_name, "PackedScene")
		
		if !ps:
			print("ERROR! !ps :" + file_name)
			return
		
		

#		var c : PoolStringArray = split_preprocess_content(contents)
#		root.parse(c)
		pass
		

	func _to_string():
		return result
		
	func get_cpp_impl_string() -> String:
		var s : String = "\n"
		s += "void construct() {\n"
		s += "\n"
		s += result
		s += "\n}\n"
		
		return s
		
func process_file(file_name : String) -> void:
	var parser : GDSSceneParser = GDSSceneParser.new()
	parser.parse(file_name)
	
	var save_base_file_path : String = file_name.get_base_dir()
	var save_base_file_name : String = file_name.get_file().to_lower().trim_suffix(".tscn")
	
	var impl_file : String = save_base_file_path + "/" + save_base_file_name + ".ctscn"
	var impl_data : String = parser.get_cpp_impl_string()
	
	print(impl_data)
	
	#file.open(impl_file, File.WRITE)
	#file.store_string(impl_data)
	#file.close()
