tool
extends Reference

class GDSStaticClassParser:
	var scope_data : String = ""
	var raw_scope_data : String = ""
	var static_methods : PoolStringArray = PoolStringArray()

	func convert_to_string(current_scope_level : int = 0) -> String:
		var s : String = scope_data + "- (" + raw_scope_data + ")---GDSScope---\n"
		
		for m in static_methods:
			s += m + "\n"
			
		s += "\n"
		
		return s
	
	func get_cpp_header_string() -> String:
		var s : String = ""
			
		s += "class _" + scope_data +  " : public Object {\n"
		s += " GDCLASS(" + scope_data + ", Object);\n\n"
				
		s += " public:\n"

		s += "\n"
		
		for m in static_methods:
			s += " " + transform_method_to_cpp(m) + ";\n"
		
		s += "\n"
		s += " static _" + scope_data + "* get_singleton();\n"
		s += "\n"
		s += " " + scope_data + "();\n"
		s += " ~" + scope_data + "();\n"
		s += "\n"
		s += " protected:\n"
		s += " static void _bind_methods();\n"
		
		s += "\n"
		s += " static _" + scope_data + "* self;\n"
			
		s += "\n"
		s += "};"
		s += "\n"
			
		return s

	func get_cpp_impl_string(current_scope_level : int = 0, owner_class_name : String = "") -> String:
		var s : String = ""
			
		s += "\n"
		
		for m in static_methods:
			#scope_data
			
			s += transform_method_to_cpp(m, "_" + scope_data + "::", false) + " {\n"
			s += " " + transform_method_to_cpp_call(m, scope_data + "::") + ";\n"
			s += "}\n\n"

		s += "_" + scope_data + "* _" + scope_data + "::get_singleton() {\n"
		s += " return self;\n"
		s += "}\n\n"
		
		s += "\n"

		s += "_" + scope_data + "::_" + scope_data + "() {\n"
		s += " self = this;\n"
		s += "}\n\n"
		
		s += "_" + scope_data + "::~_" + scope_data + "() {\n"
		s += " self = nullptr;\n"
		s += "}\n\n"
		s += "\n"
		s += "static void _" + scope_data + "::_bind_methods() {\n"
			
		s +=  create_cpp_binds_string()

		s += "}\n\n"
		
		s += "_" + scope_data + "* _" + scope_data + "::self = nullptr;\n"
			
		return s
		
	func create_cpp_binds_string() -> String:
		var s : String = ""

		for m in static_methods:
			s += " " + transform_method_to_cpp_binding(m, "_" + scope_data) + ";\n"

		s += "\n"

		return s

	func transform_method_to_cpp(func_raw_data : String, name_prefix : String = "", default_params : bool = true) -> String:
		var func_data : String = func_raw_data
		var func_ret_type : String = "void"
		
		var indx : int = func_raw_data.find(" -> ")
		
		if indx != -1:
			func_ret_type = func_raw_data.substr(indx + 4)
			func_data = func_raw_data.substr(0, indx)
			
		var func_final : String = func_ret_type + " "
		indx = func_data.find("(")
		var func_name : String = func_data.substr(0, indx)
		func_final += name_prefix + func_name + "("
		
		var func_params : String = func_data.substr(indx + 1, func_data.length() - indx - 2)
		
		if func_params != "":
			var params : PoolStringArray = func_params.split(",", false)
			
			for i in range(params.size()):
				var p : String = params[i]
				
				var default_value_indx : int = p.find("=")
				var default_value : String 
				
				if default_value_indx != -1:
					default_value = p.substr(default_value_indx + 1).strip_edges()
					p = p.substr(0, default_value_indx).strip_edges()
				
				var type_indx : int = p.find(":")
				
				if type_indx != -1:
					var param_type : String = p.substr(type_indx + 1).strip_edges()
					p = p.substr(0, type_indx).strip_edges()
					
					if param_type == "int" || param_type == "float" || param_type == "bool" || param_type == "RID":
						func_final += "const " + param_type + " "
					else:
						func_final += "const " + param_type + " &"
				else:
					func_final += "const Variant &"

				func_final += p
				
				if default_params && default_value_indx != -1:
					func_final += " = " + default_value
				
				if i + 1 < params.size():
					func_final += ", "
		
		func_final += ")"
		
		return func_final
		
	func transform_method_to_cpp_call(func_raw_data : String, name_prefix : String = "") -> String:
		var func_data : String = func_raw_data
		var func_ret_type : String = "void"
		
		var indx : int = func_raw_data.find(" -> ")
		
		if indx != -1:
			func_ret_type = func_raw_data.substr(indx + 4)
			func_data = func_raw_data.substr(0, indx)
		
		var func_final : String = ""
		
		if func_ret_type != "void":
			func_final += "return "
		
		indx = func_data.find("(")
		var func_name : String = func_data.substr(0, indx)
		func_final += name_prefix + func_name + "("
		
		var func_params : String = func_data.substr(indx + 1, func_data.length() - indx - 2)
		
		if func_params != "":
			var params : PoolStringArray = func_params.split(",", false)
			
			for i in range(params.size()):
				var p : String = params[i]
				
				var default_value_indx : int = p.find("=")
				var default_value : String 
				
				if default_value_indx != -1:
					default_value = p.substr(default_value_indx + 1).strip_edges()
					p = p.substr(0, default_value_indx).strip_edges()
				
				var type_indx : int = p.find(":")
				
				if type_indx != -1:
					var param_type : String = p.substr(type_indx + 1).strip_edges()
					p = p.substr(0, type_indx).strip_edges()

				func_final += p
				
				if i + 1 < params.size():
					func_final += ", "
		
		func_final += ")"
		
		return func_final
		
	func transform_method_to_cpp_binding(func_raw_data : String, name_prefix : String) -> String:
		var func_data : String = func_raw_data
		var func_ret_type : String = "void"
		
		var indx : int = func_raw_data.find(" -> ")
		
		if indx != -1:
			func_ret_type = func_raw_data.substr(indx + 4)
			func_data = func_raw_data.substr(0, indx)
			
		var ret_final : String = "ClassDB::bind_method(D_METHOD(\""
		
		indx = func_data.find("(")
		var func_name : String = func_data.substr(0, indx)
		ret_final += func_name + "\""
		
		var func_params : String = func_data.substr(indx + 1, func_data.length() - indx - 2)
		
		var default_values : PoolStringArray = PoolStringArray()
		
		if func_params != "":
			var params : PoolStringArray = func_params.split(",", false)
			
			for i in range(params.size()):
				ret_final += ", "
				
				var p : String = params[i]
				
				var default_value_indx : int = p.find("=")
				var default_value : String 
				
				if default_value_indx != -1:
					default_value = p.substr(default_value_indx + 1).strip_edges()
					p = p.substr(0, default_value_indx).strip_edges()
					default_values.push_back(default_value)
				
				var type_indx : int = p.find(":")
				
				if type_indx != -1:
					var param_type : String = p.substr(type_indx + 1).strip_edges()
					p = p.substr(0, type_indx).strip_edges()

				ret_final += "\"" + p + "\""

		ret_final += "), &" + name_prefix + "::" + func_name
		
		for i in range(default_values.size()):
			ret_final += ", " + default_values[i]

		ret_final += ");"
		
		return ret_final
		
	func camel_case_scope_data() -> void:
		scope_data = camel_case_name(scope_data)

	func camel_case_name(cname : String) -> String:
		var ret : String = ""
		
		var next_upper : bool = true
		for i in range(cname.length()):
			if cname[i] == "_":
				next_upper = true
				continue
				
			if next_upper:
				ret += cname[i].to_upper()
				next_upper = false
			else:
				ret += cname[i]

		return ret

	func _to_string():
		return convert_to_string()

	func parse(contentsstr : String, file_name : String) -> void:
		raw_scope_data = file_name
		scope_data = file_name.get_file().trim_suffix(".gd")
		camel_case_scope_data()
		
		var contents : PoolStringArray = split_preprocess_content(contentsstr)
		
		for current_index in range(contents.size()):
			var cl : String = contents[current_index]
			
			if cl.begins_with("class_name "):
				raw_scope_data = cl
				scope_data = cl.trim_prefix("class_name ")
				continue
				
			if cl.begins_with("#"):
				continue
				
			var clstripped : String = cl.strip_edges(true, false)
			
			if clstripped.begins_with("static func "):
				static_methods.push_back(clstripped.trim_prefix("static func ").trim_suffix(":"))
		

	func split_preprocess_content(contents : String) -> PoolStringArray:
		var ret : PoolStringArray = PoolStringArray()
		
		contents = contents.replace("\r\n", "\n")
		
		var sp : PoolStringArray = contents.split("\n")
		
		var pl : String = ""
		var accum : bool = false
		for i in range(sp.size()):
			var l : String = sp[i]
			l = l.strip_edges(false, true)
			
			var lfstrip : String = l.strip_edges(true, false)
			if lfstrip == "":
				continue
				
			if lfstrip.begins_with("#"):
				ret.append(lfstrip)
				continue
				
			if lfstrip.begins_with("export"):
				var indx = lfstrip.find("var")
				var expstr : String = lfstrip.substr(0, indx)
				
				ret.append("#" + expstr)
				l = l.replace(expstr, "")
				
			var setget_indx = l.find(" setget ")
			if setget_indx != -1:
				var setget_str : String = l.substr(setget_indx)
				ret.append("#" + setget_str)
				l = l.substr(0, setget_indx).strip_edges(false, true)
				
			var hash_symbol_index = l.find("#")
			if hash_symbol_index != -1:
				var comment_str : String = l.substr(hash_symbol_index)
				ret.append(comment_str)
				l = l.substr(0, hash_symbol_index).strip_edges(false, true)
			
			if l.ends_with("\\"):
				if !accum:
					accum = true
					pl = l
				else:
					pl += l.substr(0, l.length() - 1).strip_edges()
			else:
				if accum:
					accum = false
					ret.append(pl)
					pl = ""
				else:
					ret.append(l)
			
		return ret
		
	func get_final_cpp_header_string(file_name : String) -> String:
		var include_guard_name : String = file_name.get_file()
		include_guard_name = include_guard_name.to_upper()
		include_guard_name = include_guard_name.trim_suffix(".GD")
		include_guard_name += "_BIND_H"

		var s : String = "#ifndef " + include_guard_name + "\n"
		s += "#define " + include_guard_name + "\n"
		s += "\n\n"
		
		s += get_cpp_header_string()
		
		s += "\n\n"
		s += "#endif"
		s += "\n"
		
		s = s.replace(";;", ";")
		
		return s
		
	func get_final_cpp_impl_string(file_name : String) -> String:
		var include_name : String = file_name.get_file()
		include_name = include_name.to_lower()
		include_name = include_name.trim_suffix(".gd")
		include_name += "_bind.h"

		var s : String = "\n"
		s += "#include \"" + include_name + "\"\n"
		s += "\n\n"
		
		s += get_cpp_impl_string()
		
		s += "\n\n"
		
		s = s.replace(";;", ";")
		
		return s

func process_file(file_name : String) -> void:
	var file : File = File.new()
	file.open(file_name, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	
	var parser : GDSStaticClassParser = GDSStaticClassParser.new()
	parser.parse(contents, file_name)
	#print(parser)
	#print(parser.get_cpp_header_string(file_name))
	#print(parser.get_cpp_impl_string(file_name))
	
	var save_base_file_path : String = file_name.get_base_dir()
	var save_base_file_name : String = file_name.get_file().to_lower().trim_suffix(".gd")
	
	var header_file : String = save_base_file_path + "/" + save_base_file_name + "_bind.h"
	var impl_file : String = save_base_file_path + "/" + save_base_file_name + "_bind.cpp"
	
	var header_data : String = parser.get_final_cpp_header_string(file_name)
	var impl_data : String = parser.get_final_cpp_impl_string(file_name)
	
	file.open(header_file, File.WRITE)
	file.store_string(header_data)
	file.close()
	
	file.open(impl_file, File.WRITE)
	file.store_string(impl_data)
	file.close()

