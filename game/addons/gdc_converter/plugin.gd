tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Convert Scripts to Cpp", self, "on_convert_script_menu_clicked")
	#add_tool_menu_item("Convert Scenes to Cpp", self, "on_convert_scene_menu_clicked")

func _exit_tree():
	remove_tool_menu_item("Convert Scripts to Cpp")
	#remove_tool_menu_item("Convert Scenes to Cpp")

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
				if file_name.get_extension() == "gd":
					process_file(dir_name + file_name)
			
			file_name = dir.get_next()

class GDSSceneParser:
	var root : String

	func parse(contents : String, file_name : String) -> void:
		#root = GDSScope.new()
		#root.raw_scope_data = file_name
#		root.scope_data = file_name.get_file().trim_suffix(".gd")
#		root.camel_case_scope_data()
#		var c : PoolStringArray = split_preprocess_content(contents)
#		root.parse(c)
		pass
		

	func _to_string():
		return str(root)
		
	func get_cpp_impl_string(file_name : String) -> String:
		var include_name : String = file_name.get_file()
		include_name = include_name.to_lower()
		include_name = include_name.trim_suffix(".gd")
		include_name += ".h"

		var s : String = "\n"
		s += "#include \"" + include_name + "\"\n"
		s += "\n\n"
		
		#s += root.get_cpp_impl_string()
		
		s += "\n\n"
		
		return s
		
func process_file(file_name : String) -> void:
	var file : File = File.new()
	file.open(file_name, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	
	var parser : GDSSceneParser = GDSSceneParser.new()
	parser.parse(contents, file_name)
	
	var save_base_file_path : String = file_name.get_base_dir()
	var save_base_file_name : String = file_name.get_file().to_lower().trim_suffix(".gd")
	
	var impl_file : String = save_base_file_path + "/" + save_base_file_name + ".cpp"
	
	#var impl_data : String = parser.get_cpp_impl_string(file_name)
	
	#file.open(impl_file, File.WRITE)
	#file.store_string(impl_data)
	#file.close()
