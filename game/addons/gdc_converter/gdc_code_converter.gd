tool
extends Reference

enum GDScopeType {
	GDSCOPE_TYPE_GENERIC = 0,
	GDSCOPE_TYPE_CLASS,
	GDSCOPE_TYPE_IF,
	GDSCOPE_TYPE_ELIF,
	GDSCOPE_TYPE_ELSE,
	GDSCOPE_TYPE_FUNC,
	GDSCOPE_TYPE_FOR,
	GDSCOPE_TYPE_WHILE,
	GDSCOPE_TYPE_ENUM,
};

enum GDScopeLineType {
	GDSCOPE_TYPE_LINE = 0,
	GDSCOPE_TYPE_SCOPE,
};

class GDSScope:
	var type : int = GDScopeType.GDSCOPE_TYPE_GENERIC
	var scope_data : String = ""
	var raw_scope_data : String = ""
	var scope_data_alt : String = ""
	var raw_scope_data_alt : String = ""
	var subscopes : Array = Array()
	var scope_lines : PoolStringArray = PoolStringArray()
	var is_static : bool = false
	var scope_line_order : PoolIntArray
	
	var comment_accumulator : PoolStringArray = PoolStringArray()
	
	func apply_comments() -> void:
		for i in range(comment_accumulator.size()):
			scope_lines.append(comment_accumulator[i])
			scope_line_order.push_back(GDScopeLineType.GDSCOPE_TYPE_LINE)
			scope_line_order.push_back(scope_lines.size() - 1)
			
		comment_accumulator.resize(0)

	func parse(contents : PoolStringArray, current_index : int = 0, current_indent : int = 0) -> int:
		while current_index < contents.size():
			var cl : String = contents[current_index]
			
			if cl == "tool":
				scope_lines.append("#" + cl)
				scope_line_order.push_back(GDScopeLineType.GDSCOPE_TYPE_LINE)
				scope_line_order.push_back(scope_lines.size() - 1)
				current_index += 1
				continue
			
			if cl.begins_with("class_name "):
				type = GDScopeType.GDSCOPE_TYPE_CLASS
				raw_scope_data = cl
				scope_data = cl.trim_prefix("class_name ")
				current_index += 1
				continue
				
			if cl.begins_with("extends "):
				type = GDScopeType.GDSCOPE_TYPE_CLASS
				raw_scope_data_alt = cl
				scope_data_alt = cl.trim_prefix("extends ")
				current_index += 1
				continue
			
			if cl.begins_with("#"):
				comment_accumulator.append(cl)
				current_index += 1
				continue
				
			var curr_line_indent : int = get_indent_count(cl)
			var clstripped : String = cl.strip_edges(true, false)
			
			if curr_line_indent < current_indent:
				return current_index
				
			apply_comments()

			if cl.ends_with(":") || cl.begins_with("enum "):
				var scope : GDSScope = GDSScope.new()
				scope.parse_scope_data(clstripped)
				current_index += 1
				current_index = scope.parse(contents, current_index, curr_line_indent + 1)

				subscopes.append(scope)
				scope_line_order.push_back(GDScopeLineType.GDSCOPE_TYPE_SCOPE)
				scope_line_order.push_back(subscopes.size() - 1)
				
				comment_accumulator = scope.comment_accumulator
				scope.comment_accumulator.resize(0)
				apply_comments()
				
				#don't
				#current_index += 1
				continue

			scope_lines.append(clstripped)
			scope_line_order.push_back(GDScopeLineType.GDSCOPE_TYPE_LINE)
			scope_line_order.push_back(scope_lines.size() - 1)
			current_index += 1
		
		return current_index
		
	func parse_scope_data(s : String) -> void:
		raw_scope_data = s
		
		if raw_scope_data.begins_with("static "):
			is_static = true
			raw_scope_data = raw_scope_data.trim_prefix("static ")
		
		if raw_scope_data.begins_with("if "):
			type = GDScopeType.GDSCOPE_TYPE_IF
			scope_data = raw_scope_data.trim_prefix("if ").trim_suffix(":")
		elif raw_scope_data.begins_with("elif "):
			type = GDScopeType.GDSCOPE_TYPE_ELIF
			scope_data = raw_scope_data.trim_prefix("elif ").trim_suffix(":")
		elif raw_scope_data.begins_with("else"):
			type = GDScopeType.GDSCOPE_TYPE_ELSE
		elif raw_scope_data.begins_with("class "):
			type = GDScopeType.GDSCOPE_TYPE_CLASS
			scope_data = raw_scope_data.trim_prefix("class ").trim_suffix(":")
		elif raw_scope_data.begins_with("enum "):
			type = GDScopeType.GDSCOPE_TYPE_ENUM
			scope_data = raw_scope_data.trim_prefix("enum ").trim_suffix("{")
		elif raw_scope_data.begins_with("func "):
			type = GDScopeType.GDSCOPE_TYPE_FUNC
			scope_data = raw_scope_data.trim_prefix("func ").trim_suffix(":")
		elif raw_scope_data.begins_with("for "):
			type = GDScopeType.GDSCOPE_TYPE_FOR
			scope_data = raw_scope_data.trim_prefix("for ").trim_suffix(":")
		elif raw_scope_data.begins_with("while "):
			type = GDScopeType.GDSCOPE_TYPE_WHILE
			scope_data = raw_scope_data.trim_prefix("while ").trim_suffix(":")

	func get_indent_count(s : String) -> int:
		var c : int = 0
		
		for ch in s:
			if ch == "\t":
				c += 1
			else:
				break
		
		return c
		
	func convert_to_string(current_scope_level : int = 0) -> String:
		var indents : String = ""
		
		for i in range(current_scope_level):
			indents += " "
			
		var s : String = indents + "---GDSScope---\n"
			
		s += indents + raw_scope_data + " -- " + type_to_print_string() + " "
		s += scope_data
		
		if scope_data_alt != "":
			s += " " + scope_data_alt
			
		s += "\n"
		
		indents += " "
		
		for i in range(0, scope_line_order.size(), 2):
			if scope_line_order[i] == GDScopeLineType.GDSCOPE_TYPE_LINE:
				s += indents + scope_lines[scope_line_order[i + 1]] + "\n"
			else:
				s += "\n"
				s += subscopes[scope_line_order[i + 1]].convert_to_string(current_scope_level + 1)
		
		s += "\n"
			
		return s
	
	
	func type_to_print_string() -> String:
		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			return "(CLASS)"
		elif type == GDScopeType.GDSCOPE_TYPE_IF:
			return "(IF)"
		elif type == GDScopeType.GDSCOPE_TYPE_ELIF:
			return "(ELIF)"
		elif type == GDScopeType.GDSCOPE_TYPE_ELSE:
			return "(ELSE)"
		elif type == GDScopeType.GDSCOPE_TYPE_FUNC:
			return "(FUNC)"
		elif type == GDScopeType.GDSCOPE_TYPE_FOR:
			return "(FOR)"
		elif type == GDScopeType.GDSCOPE_TYPE_WHILE:
			return "(WHILE)"
		elif type == GDScopeType.GDSCOPE_TYPE_ENUM:
			return "(ENUM)"
		elif type == GDScopeType.GDSCOPE_TYPE_GENERIC:
			return "(GEN)"

		return "(UNKN)"
		
	func type_to_cpp_entity() -> String:
		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			return "class "
		elif type == GDScopeType.GDSCOPE_TYPE_IF:
			return "if "
		elif type == GDScopeType.GDSCOPE_TYPE_ELIF:
			return "else if "
		elif type == GDScopeType.GDSCOPE_TYPE_ELSE:
			return "else "
		elif type == GDScopeType.GDSCOPE_TYPE_FUNC:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_FOR:
			return "for "
		elif type == GDScopeType.GDSCOPE_TYPE_WHILE:
			return "while "
		elif type == GDScopeType.GDSCOPE_TYPE_ENUM:
			return "enum "
		elif type == GDScopeType.GDSCOPE_TYPE_GENERIC:
			return ""

		return ""

	func get_cpp_header_string(current_scope_level : int = 0) -> String:
		if type == GDScopeType.GDSCOPE_TYPE_IF:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_ELIF:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_ELSE:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_FOR:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_WHILE:
			return ""
		elif type == GDScopeType.GDSCOPE_TYPE_GENERIC:
			return ""
		
		var indents : String = ""
		
		for i in range(current_scope_level):
			indents += " "
			
		var s : String = ""
			
		s += indents + type_to_cpp_entity() 
		
		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			s += scope_data 
			
			if scope_data_alt != "":
				s += " : public " + scope_data_alt
			
			s += " {\n"
			
			if scope_data_alt != "":
				s += indents + " GDCLASS(" + scope_data + ", " + scope_data_alt + ");\n\n"
				
			s += indents + " public:\n"

		elif type == GDScopeType.GDSCOPE_TYPE_FUNC:
			if is_static:
				s += "static "
			
			s += transform_method_to_cpp() + ";"
			return s
		elif type == GDScopeType.GDSCOPE_TYPE_ENUM:
			s += scope_data + " {"
		
		s += "\n"
		
		indents += " "
		
		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			for l in scope_lines:
				var gs : String = create_cpp_getter_setter(l, true, indents)
				
				if gs != "":
					s += gs + "\n"
			
		for subs in subscopes:
			var scstr : String = subs.get_cpp_header_string(current_scope_level + 1)
			
			if scstr != "":
				s += scstr
				s += "\n"
		
		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			s += "\n"
			s += indents + scope_data + "();\n"
			s += indents + "~" + scope_data + "();\n"
			s += "\n"
			s += indents + "protected:\n"
			s += indents + "static void _bind_methods();\n"
			
		s += "\n"
		
		if type != GDScopeType.GDSCOPE_TYPE_ENUM:
			for l in scope_lines:
				if l.begins_with("#"):
					l = l.replace("#", "//")
					s += indents + l + "\n"
					continue
					
				if l.begins_with("var "):
					s += indents + transform_variable_to_cpp(l) + ";\n"
				else:
					s += indents + l + ";\n"
		else:
			for l in scope_lines:
				if l.begins_with("#"):
					l = l.replace("#", "//")
					s += indents + l + "\n"
					continue

				s += indents + l + "\n"
		
		if type == GDScopeType.GDSCOPE_TYPE_CLASS || type == GDScopeType.GDSCOPE_TYPE_ENUM:
			s += "};"
		else:
			s += "}"
		
		s += "\n"
			
		return s

	func get_cpp_impl_string(current_scope_level : int = 0, owner_class_name : String = "") -> String:
		if type == GDScopeType.GDSCOPE_TYPE_ENUM:
			return ""
		
		var indents : String = ""
		
		for i in range(current_scope_level):
			indents += " "
			
		var s : String = ""
			
		s += indents
		
		if type == GDScopeType.GDSCOPE_TYPE_IF:
			scope_data = scope_data.replace(" and ", " && ")
			scope_data = scope_data.replace(" or ", " || ")
			
			s += "if (" + scope_data + ") {"
		elif type == GDScopeType.GDSCOPE_TYPE_ELIF:
			scope_data = scope_data.replace(" and ", " && ")
			scope_data = scope_data.replace(" or ", " || ")
			
			s += "else if (" + scope_data  + ") {"
		elif type == GDScopeType.GDSCOPE_TYPE_ELSE:
			s += "else {"
		elif type == GDScopeType.GDSCOPE_TYPE_FOR:
			var range_indx : int = scope_data.find("range(")
			if range_indx != -1:
				var var_end_indx : int = scope_data.find(" in ")
				if var_end_indx != -1:
					var var_str : String = scope_data.substr(0, var_end_indx)
					var range_str : String = scope_data.substr(range_indx + 6, scope_data.length() - range_indx - 1 - 6)
					var ranges : PoolStringArray = range_str.split(",")
					
					if ranges.size() == 1:
						s += "for (int " + var_str  + " = 0; " + var_str + " < " + ranges[0] + "; ++" + var_str + ") { //" + scope_data
					elif ranges.size() == 2:
						s += "for (int " + var_str  + " = " + ranges[0] + "; " + var_str + " < " + ranges[1] + "; ++" + var_str + ") { //" + scope_data
					elif ranges.size() == 3:
						s += "for (int " + var_str  + " = " + ranges[0] + "; " + var_str + " > " + ranges[1] + "; " + var_str + " += " + ranges[2] + ") { //" + scope_data
					else:
						s += "for (" + scope_data  + ") {"
				else:
					s += "for (" + scope_data  + ") {"
			else:
				s += "for (" + scope_data  + ") {"
		elif type == GDScopeType.GDSCOPE_TYPE_WHILE:
			scope_data = scope_data.replace(" and ", " && ")
			scope_data = scope_data.replace(" or ", " || ")
			
			s += "while (" + scope_data  + ") {"
		elif type == GDScopeType.GDSCOPE_TYPE_GENERIC:
			s += scope_data  + " {"
		elif type == GDScopeType.GDSCOPE_TYPE_FUNC:
			s += transform_method_to_cpp(owner_class_name, false)  + " {"
		elif type == GDScopeType.GDSCOPE_TYPE_CLASS:
			owner_class_name = scope_data + "::"
			
			for l in scope_lines:
				var gs : String = create_cpp_getter_setter(l, false, indents, owner_class_name)
				
				if gs != "":
					s += gs + "\n"
		
		s += "\n"
		indents += " "

		for i in range(0, scope_line_order.size(), 2):
			if scope_line_order[i] == GDScopeLineType.GDSCOPE_TYPE_LINE:
				var l : String = scope_lines[scope_line_order[i + 1]]
					
				if l.begins_with("#"):
					l = l.replace("#", "//")
					s += indents + l + ";\n"
					continue

				if l.begins_with("var "):
					if l.find("preload") != -1:
						s += indents + "//" + l + ";\n"
						continue
							
					s += indents + " " + transform_variable_to_cpp(l) + ";\n"
				else:
					s += indents + l + ";\n"
			else:
				var scstr : String = subscopes[scope_line_order[i + 1]].get_cpp_impl_string(current_scope_level + 1, owner_class_name)
				
				if scstr != "":
					s += "\n"
					s += scstr
					s += "\n"
			
		s += "}\n"
			

		if type == GDScopeType.GDSCOPE_TYPE_CLASS:
			s += "\n"
			s += indents + scope_data + "::" + scope_data + "() {\n"
			
			for l in scope_lines:
				if l.find("preload") != -1:
					s += indents + "//" + l + ";\n"
				elif l.begins_with("var "):
					var vcpp : String = transform_variable_to_cpp(l)
					var index_fs : int = vcpp.find(" ")
					if index_fs != -1:
						vcpp = vcpp.substr(index_fs + 1)

					s += indents + " " + vcpp + ";\n"
			
			s += indents + "}\n\n"
			s += indents + scope_data + "::~" + scope_data + "() {\n"
			s += indents + "}\n\n"
			s += "\n"
			s += indents + "static void " + scope_data + "::_bind_methods() {\n"
			
			for l in scope_lines:
				var gs : String = create_cpp_getter_setter_bind(l, indents + " ", scope_data)
				
				if gs != "":
					s += gs + "\n"
			
			s +=  create_cpp_binds_string(indents.length() + 1)

			s += indents + "}\n\n"
			
		return s
		
	func create_cpp_binds_string(current_scope_level : int = 0) -> String:
		if type != GDScopeType.GDSCOPE_TYPE_CLASS:
			return ""
		
		var indents : String = ""
		
		for i in range(current_scope_level):
			indents += " "
			
		var s : String = ""

		for subs in subscopes:
			if subs.type != GDScopeType.GDSCOPE_TYPE_FUNC:
				continue
			
			if subs.is_static:
				continue
			
			var scstr : String = subs.transform_method_to_cpp_binding(scope_data)
			
			if scstr != "":
				s += indents + scstr
				s += "\n"
		
		s += "\n"

		return s

	func create_cpp_getter_setter(line : String, header : bool, indent : String, class_prefix : String = "") -> String:
		if !line.begins_with("var "):
			return ""
		
		var cpp_var : String = transform_variable_to_cpp(line)
		
		var equals_index = cpp_var.find("=")
		if equals_index != -1:
			cpp_var = cpp_var.substr(0, equals_index)
		
		cpp_var = cpp_var.strip_edges()
		
		var name_start_index : int = cpp_var.find_last(" ")
		var var_type : String = cpp_var.substr(0, name_start_index).strip_edges()
		var var_name : String = cpp_var.substr(name_start_index + 1).strip_edges()
		
		var ret_final : String = ""
		
		if var_type == "int" || var_type == "float" || var_type == "bool" || var_type == "RID":
			ret_final += indent + var_type + " " + class_prefix + "get_" + var_name + "() const"
			
			if !header:
				ret_final += " {\n";
				ret_final += indent + " return " + var_name + ";\n"
				ret_final += indent + "}\n\n";
			else:
				ret_final += ";\n"
				
			ret_final += indent + "void " + class_prefix + "set_" + var_name + "(const " + var_type + " val)"
			
			if !header:
				ret_final += " {\n";
				ret_final += indent + var_name + " = val;\n"
				ret_final += indent + "}\n\n";
			else:
				ret_final += ";\n"
		else:
			ret_final += indent + var_type + " " + class_prefix + "get_" + var_name + "()"
			
			if !header:
				ret_final += " {\n";
				ret_final += indent + " return " + var_name + ";\n"
				ret_final += indent + "}\n\n";
			else:
				ret_final += ";\n"
			
			ret_final += indent + "void " + class_prefix + "set_" + var_name + "(const " + var_type + " &val)"
			
			if !header:
				ret_final += " {\n";
				ret_final += indent + var_name + " = val;\n"
				ret_final += indent + "}\n\n";
			else:
				ret_final += ";\n"
			
		return ret_final

	func create_cpp_getter_setter_bind(line : String, indent : String, owner_class_name : String) -> String:
		if !line.begins_with("var "):
			return ""
		
		var cpp_var : String = transform_variable_to_cpp(line)
		
		var equals_index = cpp_var.find("=")
		if equals_index != -1:
			cpp_var = cpp_var.substr(0, equals_index)
		
		cpp_var = cpp_var.strip_edges()
		
		var name_start_index : int = cpp_var.find_last(" ")
		var var_type : String = cpp_var.substr(0, name_start_index).strip_edges()
		var var_name : String = cpp_var.substr(name_start_index + 1).strip_edges()
		
		var ret_final : String = ""
		
		ret_final += indent + " ClassDB::bind_method(D_METHOD(\"get_" + var_name + "\"), &" + owner_class_name + "::get_" + var_name + ");\n"
		ret_final += indent + " ClassDB::bind_method(D_METHOD(\"set_" + var_name + "\", \"value\"), &" + owner_class_name + "::set_" + var_name + ");\n"
		
		ret_final += indent + " ADD_PROPERTY(PropertyInfo(Variant::"
		
		var is_object : bool = false
		
		if var_type == "bool":
			ret_final += "BOOL"
		elif var_type == "int":
			ret_final += "INT"
		elif var_type == "float" || var_type == "double":
			ret_final += "REAL"
		elif var_type == "String":
			ret_final += "STRING"
		elif var_type == "Vector2":
			ret_final += "VECTOR2"
		elif var_type == "Vector2i":
			ret_final += "VECTOR2I"
		elif var_type == "Rect2":
			ret_final += "RECT2"
		elif var_type == "Rect2i":
			ret_final += "RECT2I"
		elif var_type == "Vector3":
			ret_final += "VECTOR3"
		elif var_type == "Vector3i":
			ret_final += "VECTOR3I"
		elif var_type == "Transform2D":
			ret_final += "TRANSFORM2D"
		elif var_type == "Plane":
			ret_final += "PLANE"
		elif var_type == "Quat":
			ret_final += "QUAT"
		elif var_type == "AABB":
			ret_final += "AABB"
		elif var_type == "Basis":
			ret_final += "BASIS"
		elif var_type == "Transform":
			ret_final += "TRANSFORM"
		elif var_type == "Color":
			ret_final += "COLOR"
		elif var_type == "NodePath":
			ret_final += "NODE_PATH"
		elif var_type == "RID":
			ret_final += "_RID"
		elif var_type == "Object":
			ret_final += "OBJECT"
			is_object = true
		elif var_type == "StringName":
			ret_final += "STRING_NAME"
		elif var_type == "Dictionary":
			ret_final += "DICTIONARY"
		elif var_type == "Array":
			ret_final += "ARRAY"
		elif var_type == "PoolByteArray":
			ret_final += "POOL_BYTE_ARRAY"
		elif var_type == "PoolIntArray":
			ret_final += "POOL_INT_ARRAY"
		elif var_type == "PoolRealArray":
			ret_final += "POOL_REAL_ARRAY"
		elif var_type == "PoolStringArray":
			ret_final += "POOL_STRING_ARRAY"
		elif var_type == "PoolVector2Array":
			ret_final += "POOL_VECTOR2_ARRAY"
		elif var_type == "PoolVector2iArray":
			ret_final += "POOL_VECTOR2I_ARRAY"
		elif var_type == "PoolVector3Array":
			ret_final += "POOL_VECTOR3_ARRAY"
		elif var_type == "PoolVector3iArray":
			ret_final += "POOL_VECTOR3I_ARRAY"
		elif var_type == "PoolColorArray":
			ret_final += "POOL_COLOR_ARRAY"
		else:
			ret_final += "OBJECT"
			is_object = true
		
		if is_object:
			ret_final += ", \"" + var_name + "\", PROPERTY_HINT_RESOURCE_TYPE, \"" + var_type + "\"), \"set_" + var_name + "\", \"get_" + var_name + "\");"
		else:
			ret_final += ", \"" + var_name + "\"), \"set_" + var_name + "\", \"get_" + var_name + "\");"
			
		ret_final += "\n\n"

		return ret_final

	func transform_variable_assign(line : String) -> String:
		
		if !line.ends_with(" as "):
			return line
		
		#This should hadnle primitive types like int
		if !line.ends_with(".new()"):
			return line
			
		return line

	func transform_variable_to_cpp(line : String) -> String:
		line = line.replace("var ", "")
		
		var var_final : String = ""
		
		var param_type : String
		var var_name : String
		var assigned_value : String 
		
		var assigned_value_indx : int = line.find("=")
		
		if assigned_value_indx != -1:
			assigned_value = line.substr(assigned_value_indx + 1).strip_edges()
			line = line.substr(0, assigned_value_indx).strip_edges()
			assigned_value = transform_variable_assign(assigned_value)
				
		var type_indx : int = line.find(":")
		if type_indx != -1:
			param_type = line.substr(type_indx + 1).strip_edges()
			var_name = line.substr(0, type_indx).strip_edges()
		if param_type == "int" || param_type == "float" || param_type == "bool" || param_type == "RID":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Vector2" || param_type == "Vector2i":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Vector3" || param_type == "Vector3i":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Rect2" || param_type == "Rect2i":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Transform" || param_type == "Transform2D":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "String" || param_type == "StringName":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Quat" || param_type == "Plane":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "NodePath" || param_type == "Dictionary":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Color" || param_type == "Basis":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "Array" || param_type == "AABB":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "PoolByteArray" || param_type == "PoolColorArray":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "PoolIntArray" || param_type == "PoolRealArray":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "PoolVector2Array" || param_type == "PoolVector2iArray":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "PoolVector3Array" || param_type == "PoolVector3iArray":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type == "PoolStringArray":
			var_final += param_type + " " + var_name + " = " + assigned_value
		elif param_type != "":
			if ClassDB.class_exists(param_type):
				#check if it's a reference
				var is_ref : bool = false
				var pcls : String = param_type
				while pcls != "Object":
					pcls = ClassDB.get_parent_class(pcls)

					if pcls == "Reference":
						is_ref = true
						break
						
				if is_ref:
					var_final += "Ref<" + param_type + "> " + var_name
				else:
					var_final += param_type + " *" + var_name
					
				if assigned_value != "":
					var_final += " = " + assigned_value
			else:
				#Assume it needs a pointer
				var_final += param_type + " *" + var_name
				
				if assigned_value != "":
					var_final += " = " + assigned_value
		else:
			var_final += "Variant "  + var_name
			
			if assigned_value != "":
				var_final += " = " + assigned_value
			
		return var_final

	func transform_method_to_cpp(name_prefix : String = "", default_params : bool = true) -> String:
		if type != GDScopeType.GDSCOPE_TYPE_FUNC:
			return ""
		
		var func_data : String = scope_data
		var func_ret_type : String = "void"
		
		var indx : int = scope_data.find(" -> ")
		
		if indx != -1:
			func_ret_type = scope_data.substr(indx + 4)
			func_data = scope_data.substr(0, indx)
			
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
		
	func transform_method_to_cpp_binding(name_prefix : String) -> String:
		if type != GDScopeType.GDSCOPE_TYPE_FUNC:
			return ""
		
		var func_data : String = scope_data
		var func_ret_type : String = "void"
		
		var indx : int = scope_data.find(" -> ")
		
		if indx != -1:
			func_ret_type = scope_data.substr(indx + 4)
			func_data = scope_data.substr(0, indx)
			
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



class GDSParser:
	var root : GDSScope
	
	func parse(contents : String, file_name : String) -> void:
		root = GDSScope.new()
		root.raw_scope_data = file_name
		root.scope_data = file_name.get_file().trim_suffix(".gd")
		root.camel_case_scope_data()
		var c : PoolStringArray = split_preprocess_content(contents)
		root.parse(c)
		root.apply_comments()
		

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
				var comment_str : String = l.substr(hash_symbol_index).strip_edges(true, false)
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
		
	func _to_string():
		return str(root)
		
	func get_cpp_header_string(file_name : String) -> String:
		var include_guard_name : String = file_name.get_file()
		include_guard_name = include_guard_name.to_upper()
		include_guard_name = include_guard_name.trim_suffix(".GD")
		include_guard_name += "_H"

		var s : String = "#ifndef " + include_guard_name + "\n"
		s += "#define " + include_guard_name + "\n"
		s += "\n\n"
		
		s += root.get_cpp_header_string()
		
		s += "\n\n"
		s += "#endif"
		s += "\n"
		
		s = s.replace(";;", ";")
		
		return s
		
	func get_cpp_impl_string(file_name : String) -> String:
		var include_name : String = file_name.get_file()
		include_name = include_name.to_lower()
		include_name = include_name.trim_suffix(".gd")
		include_name += ".h"

		var s : String = "\n"
		s += "#include \"" + include_name + "\"\n"
		s += "\n\n"
		
		s += root.get_cpp_impl_string()
		
		s += "\n\n"
		
		s = s.replace(";;", ";")
		
		return s

func process_file(file_name : String) -> void:
	var file : File = File.new()
	file.open(file_name, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	
	var parser : GDSParser = GDSParser.new()
	parser.parse(contents, file_name)
	#print(parser)
	#print(parser.get_cpp_header_string(file_name))
	#print(parser.get_cpp_impl_string(file_name))
	
	var save_base_file_path : String = file_name.get_base_dir()
	var save_base_file_name : String = file_name.get_file().to_lower().trim_suffix(".gd")
	
	var header_file : String = save_base_file_path + "/" + save_base_file_name + ".h"
	var impl_file : String = save_base_file_path + "/" + save_base_file_name + ".cpp"
	
	var header_data : String = parser.get_cpp_header_string(file_name)
	var impl_data : String = parser.get_cpp_impl_string(file_name)
	
	file.open(header_file, File.WRITE)
	file.store_string(header_data)
	file.close()
	
	file.open(impl_file, File.WRITE)
	file.store_string(impl_data)
	file.close()

