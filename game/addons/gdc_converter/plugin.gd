tool
extends EditorPlugin


func _enter_tree():
	add_tool_menu_item("Convert scripts", self, "on_menu_clicked")

func _exit_tree():
	remove_tool_menu_item("Convert scripts")

func on_menu_clicked(val) -> void:
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "gd":
					process_file(dir_name + file_name)
					return
			
			file_name = dir.get_next()
			

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

class GDSScope:
	var type : int = GDScopeType.GDSCOPE_TYPE_GENERIC
	var scope_data : String = ""
	var raw_scope_data : String = ""
	var scope_data_alt : String = ""
	var raw_scope_data_alt : String = ""
	var subscopes : Array = Array()
	var scope_lines : PoolStringArray = PoolStringArray()

	func parse(contents : PoolStringArray, current_index : int = 0, current_indent : int = 0) -> int:
		while current_index < contents.size():
			var cl : String = contents[current_index]
			
			if cl == "tool":
				scope_lines.append("#" + cl)
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
				scope_lines.append(cl)
				current_index += 1
				continue
				
			var curr_line_indent : int = get_indent_count(cl)
			var clstripped : String = cl.strip_edges(true, false)
			
			if curr_line_indent < current_indent:
				return current_index
			
			if cl.ends_with(":") || cl.begins_with("enum "):
				var scope : GDSScope = GDSScope.new()
				scope.parse_scope_data(clstripped)
				current_index += 1
				current_index = scope.parse(contents, current_index, curr_line_indent + 1)
				subscopes.append(scope)
				
				#don't
				#current_index += 1
				continue
			
			scope_lines.append(clstripped)
			current_index += 1
		
		return current_index
		
	func parse_scope_data(s : String) -> void:
		raw_scope_data = s
		
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
		
		for l in scope_lines:
			s += indents + l + "\n"
			
		for subs in subscopes:
			s += "\n"
			s += subs.convert_to_string(current_scope_level + 1)
			
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
				s += indents + " GDCLASS(" + scope_data + ", " + scope_data_alt + ")\n\n"
				
			s += indents + " public:\n"

		elif type == GDScopeType.GDSCOPE_TYPE_FUNC:
			s += scope_data + ";"
			return s
		elif type == GDScopeType.GDSCOPE_TYPE_ENUM:
			s += scope_data + " {"
		
		s += "\n"
		
		indents += " "
		
		for l in scope_lines:
			if l.begins_with("#"):
				l = l.replace("#", "//")
				s += indents + l + "\n"
				continue

			l = l.replace("#", ";//")
			s += indents + l + ";\n"
			
		s += "\n"
			
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
			
		
		if type == GDScopeType.GDSCOPE_TYPE_CLASS || type == GDScopeType.GDSCOPE_TYPE_ENUM:
			s += "};"
		else:
			s += "}"
		
		s += "\n"
			
		return s

	func _to_string():
		return convert_to_string()

class GDSParser:
	var root : GDSScope
	
	func parse(contents : String, file_name : String) -> void:
		root = GDSScope.new()
		root.raw_scope_data = file_name
		root.scope_data = file_name.get_file().trim_suffix(".gd")
		var c : PoolStringArray = split_preprocess_content(contents)
		root.parse(c)
	
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
		
		return s


func process_file(file_name : String) -> void:
	var file : File = File.new()
	file.open(file_name, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	
	var parser : GDSParser = GDSParser.new()
	parser.parse(contents, file_name)
	#print(parser)
	print(parser.get_cpp_header_string(file_name))
	
