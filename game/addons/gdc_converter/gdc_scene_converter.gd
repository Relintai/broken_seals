tool
extends Reference

class GDSSceneParser:
	var result : String

	func parse(file_name : String) -> void:
		var ps : PackedScene = ResourceLoader.load(file_name, "PackedScene")
		
		if !ps:
			print("ERROR! !ps :" + file_name)
			return
		
		var node : Node = ps.instance()
		
		process_node(node)


	func process_node(node : Node) -> void:
		var node_name : String = node.get_name()
		
		var nn : Node = node.get_parent()
		while nn:
			node_name += "_" + nn.get_name()
			nn = nn.get_parent()
			
		node_name = node_name.to_lower()
		
		var nscript : Script = node.get_script()
		
		if nscript:
			result += "//Script: " + nscript.resource_path + "\n"

		result += node.get_class() + " *" + node_name + " = memnew(" + node.get_class() + ");\n"
		result += node_name + "->set_name(\"" + node.get_name() + "\");\n"
		var node_parent : Node = node.get_parent()
		if node_parent:
			var node_parent_name : String = node_parent.get_name()
			
			var nnp : Node = node_parent.get_parent()
			while nnp:
				node_parent_name += "_" + nnp.get_name()
				nnp = nnp.get_parent()
				
			node_parent_name = node_parent_name.to_lower()
			result += node_parent_name + "->add_child(" + node_name + ");\n"
			
		var node_def_copy : Node = ClassDB.instance(node.get_class())
		node_def_copy.set_script(node.get_script())
		
		result += "\n"
		
		var props : Array = node.get_property_list()
		
		for p in props:
			var property_name : String = p["name"]
			
			var prop_value = node.get(property_name)
			if prop_value != node_def_copy.get(property_name):
				var property_type : int = p["type"]
				
				if property_type == TYPE_BOOL || property_type == TYPE_INT || property_type == TYPE_REAL:
					result += node_name + "->set_" + property_name + "(" + str(prop_value) + ");\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", " + str(prop_value) + ");\n"
				elif property_type == TYPE_STRING:
					result += node_name + "->set_" + property_name + "(\"" + prop_value + "\");\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", \"" + prop_value + "\");\n"
				elif property_type == TYPE_VECTOR2:
					result += node_name + "->set_" + property_name + "(Vector2(" + str(prop_value.x) + ", " + str(prop_value.y) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Vector2(" + str(prop_value.x) + ", " + str(prop_value.y) + "));\n"
				elif property_type == TYPE_VECTOR2I:
					result += node_name + "->set_" + property_name + "(Vector2i(" + str(prop_value.x) + ", " + str(prop_value.y) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Vector2i(" + str(prop_value.x) + ", " + str(prop_value.y) + "));\n"
				elif property_type == TYPE_RECT2:
					result += node_name + "->set_" + property_name + "(Rect2(" + str(prop_value.position.x) + ", " + str(prop_value.position.y) + ", " + str(prop_value.size.y) + ", " + str(prop_value.size.y) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Rect2(" + str(prop_value.position.x) + ", " + str(prop_value.position.y) + ", " + str(prop_value.size.y) + ", " + str(prop_value.size.y) + "));\n"
				elif property_type == TYPE_RECT2I:
					result += node_name + "->set_" + property_name + "(Rect2i(" + str(prop_value.position.x) + ", " + str(prop_value.position.y) + ", " + str(prop_value.size.y) + ", " + str(prop_value.size.y) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Rect2i(" + str(prop_value.position.x) + ", " + str(prop_value.position.y) + ", " + str(prop_value.size.y) + ", " + str(prop_value.size.y) + "));\n"
				elif property_type == TYPE_VECTOR3:
					result += node_name + "->set_" + property_name + "(Vector3(" + str(prop_value.x) + ", " + str(prop_value.y) + ", " + str(prop_value.z) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Vector3(" + str(prop_value.x) + ", " + str(prop_value.y) + ", " + str(prop_value.z) + "));\n"
				elif property_type == TYPE_VECTOR3I:
					result += node_name + "->set_" + property_name + "(Vector3i(" + str(prop_value.x) + ", " + str(prop_value.y) + ", " + str(prop_value.z) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Vector3i(" + str(prop_value.x) + ", " + str(prop_value.y) + ", " + str(prop_value.z) + "));\n"
				elif property_type == TYPE_TRANSFORM2D:
					result += "//" + node_name + " property " + property_name + " TYPE_TRANSFORM2D value: " + str(prop_value) + "\n"
				elif property_type == TYPE_PLANE:
					result += "//" + node_name + " property " + property_name + " TYPE_PLANE value: " + str(prop_value) + "\n"
				elif property_type == TYPE_QUAT:
					result += "//" + node_name + " property " + property_name + " TYPE_QUAT value: " + str(prop_value) + "\n"
				elif property_type == TYPE_AABB:
					result += "//" + node_name + " property " + property_name + " TYPE_AABB value: " + str(prop_value) + "\n"
				elif property_type == TYPE_BASIS:
					result += "//" + node_name + " property " + property_name + " TYPE_BASIS value: " + str(prop_value) + "\n"
				elif property_type == TYPE_TRANSFORM:
					result += "//" + node_name + " property " + property_name + " TYPE_TRANSFORM value: " + str(prop_value) + "\n"
				elif property_type == TYPE_COLOR:
					result += node_name + "->set_" + property_name + "(Color(" + str(prop_value.r) + ", " + str(prop_value.g) + ", " + str(prop_value.b) + ", " + str(prop_value.a) + "));\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", Color(" + str(prop_value.r) + ", " + str(prop_value.g) + ", " + str(prop_value.b) + ", " + str(prop_value.a) + "));\n"
				elif property_type == TYPE_NODE_PATH:
					result += "//" + node_name + " property " + property_name + " TYPE_NODE_PATH value: " + str(prop_value) + "\n"
				elif property_type == TYPE_RID:
					result += "//" + node_name + " property " + property_name + " TYPE_RID value: " + str(prop_value) + "\n"
				elif property_type == TYPE_STRING_NAME:
					result += node_name + "->set_" + property_name + "(\"" + prop_value + "\");\n"
					result += "//" + node_name + "->set(\"" + property_name + "\", " + prop_value + "));\n"
				elif property_type == TYPE_DICTIONARY:
					result += "//" + node_name + " property " + property_name + " TYPE_DICTIONARY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_RAW_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_RAW_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_INT_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_INT_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_REAL_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_REAL_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_STRING_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_STRING_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_VECTOR2_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_VECTOR2_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_VECTOR2I_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_VECTOR2I_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_VECTOR3_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_VECTOR3_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_VECTOR3I_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_VECTOR3I_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_COLOR_ARRAY:
					result += "//" + node_name + " property " + property_name + " TYPE_COLOR_ARRAY value: " + str(prop_value) + "\n"
				elif property_type == TYPE_OBJECT:
					result += "//" + node_name + " property " + property_name + " TYPE_OBJECT value: " + str(prop_value) + "\n"
					if prop_value:
						var is_reference : bool = false
						var curr_pclass : String = prop_value.get_class()
						while curr_pclass != "Object":
							if curr_pclass == "Reference":
								is_reference = true
								break
							
							curr_pclass = ClassDB.get_parent_class(curr_pclass)
							
						if is_reference:
							result += "Ref<" + prop_value.get_class() + "> " + node_name + "_prop_" + property_name + ";\n"
							result += node_name + "_prop_" + property_name + ".instance();\n"
							result += node_name + "->set_" + property_name + "(" + node_name + "_prop_" + property_name + ");\n"
							result += "//" + node_name + "->set(\"" + property_name + "\", " + node_name + "_prop_" + property_name + ");\n"
					else:
						result += node_name + "->set_" + property_name + "(nullptr);\n"
						result += "//" + node_name + "->set(\"" + property_name + "\", nullptr);\n"
				else:
					result += "//" + node_name + " property " + property_name + " value: " + str(prop_value) + "\n"
					
				result += "\n"
					
		result += "\n\n"
		
		for n in node.get_children():
			process_node(n)

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
	
	#print(impl_data)
	var file : File = File.new()
	file.open(impl_file, File.WRITE)
	file.store_string(impl_data)
	file.close()
