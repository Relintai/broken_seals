extends VBoxContainer

export(NodePath) var tree_path : NodePath
var tree : Tree

export(NodePath) var rtl_path : NodePath
var rtl : RichTextLabel

var populated : bool = false

var _data : Array = Array()

enum AttibutionIndex {
	ATTRIBUTION_INDEX_NAME = 0,
	ATTRIBUTION_INDEX_URL = 1,
	ATTRIBUTION_INDEX_DESCRIPTION = 2,
	ATTRIBUTION_INDEX_LICENSES = 3,
	ATTRIBUTION_INDEX_FILES = 4,
	ATTRIBUTION_INDEX_MAX = 5,
}

func _enter_tree():
	tree = get_node(tree_path)  as Tree
	rtl = get_node(rtl_path) as RichTextLabel
	
	connect("visibility_changed", self, "on_visibility_changed")
	tree.connect("item_selected", self, "on_item_selected")
	
func on_visibility_changed():
	if visible:
		populate()
		
func on_item_selected():
	rtl.text = tree.get_selected().get_metadata(0)

func populate():
	if populated:
		return
		
	populated = true
	
	#root
	tree.create_item()
	
	_data.clear()
	load_all_xmls("res://")
	
	for entry in _data:
		var main : TreeItem = tree.create_item()
		
		main.set_text(0, entry[0][0])
		main.set_metadata(0, data_arr_to_string(entry[0]))
		
		for i in range(1, entry.size()):
			var curr : TreeItem = tree.create_item(main)

			curr.set_text(0, entry[i][0])
			curr.set_metadata(0, data_arr_to_string(entry[i]))
		
func load_all_xmls(path : String) -> void:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue

			if dir.current_is_dir():
				if path == "res://":
					load_all_xmls(path + file_name)
				else:
					load_all_xmls(path + "/" + file_name)
			else:
				if file_name == "Attributions.xml":
					if path == "res://":
						load_xml(path + file_name)
					else:
						load_xml(path + "/" + file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: " + path)

func load_xml(path : String) -> void:
	var parser : XMLParser = XMLParser.new()
	var err = parser.open(path)
	
	if err != OK:
		print("Couldn't open file: " + path + " Err: " + err)
		return

	var attributions : Array = Array()
	attributions.resize(1)
	var attrib : PoolStringArray = PoolStringArray()
	attrib.resize(AttibutionIndex.ATTRIBUTION_INDEX_MAX)
	var curr_element : String = ""
	while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			curr_element = parser.get_node_name()
			
		elif parser.get_node_type() == XMLParser.NODE_TEXT:
			if curr_element == "Name":
				attrib[AttibutionIndex.ATTRIBUTION_INDEX_NAME] = parser.get_node_data()
			elif curr_element == "Description":
				attrib[AttibutionIndex.ATTRIBUTION_INDEX_DESCRIPTION] = parser.get_node_data()
			elif curr_element == "Licenses":
				attrib[AttibutionIndex.ATTRIBUTION_INDEX_LICENSES] = parser.get_node_data()
			elif curr_element == "URL":
				attrib[AttibutionIndex.ATTRIBUTION_INDEX_URL] = parser.get_node_data()
			elif curr_element == "Files":
				attrib[AttibutionIndex.ATTRIBUTION_INDEX_FILES] = parser.get_node_data()
				
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			if parser.get_node_name() == "Attribution":
				attributions.push_back(attrib)
				attrib = PoolStringArray()
				attrib.resize(AttibutionIndex.ATTRIBUTION_INDEX_MAX)
			elif parser.get_node_name() == "Module":
				attributions[0] = attrib
				attrib = PoolStringArray()
				attrib.resize(AttibutionIndex.ATTRIBUTION_INDEX_MAX)
				
	if attributions[0] == null:
		print("Attributions file does not have a Module tag! Path: " + path)
		
	_data.push_back(attributions)

func data_arr_to_string(arr : Array) -> String:
	var s : String = ""
	
	s += arr[AttibutionIndex.ATTRIBUTION_INDEX_NAME] + "\n\n"
	
	if arr[AttibutionIndex.ATTRIBUTION_INDEX_URL] != "":
		s += "url: " + arr[AttibutionIndex.ATTRIBUTION_INDEX_URL] + "\n\n"
		
	s += arr[AttibutionIndex.ATTRIBUTION_INDEX_DESCRIPTION] + "\n\n"
	
	s += "License(s):\n"
	s += arr[AttibutionIndex.ATTRIBUTION_INDEX_LICENSES] + "\n\n"
	
	if arr[AttibutionIndex.ATTRIBUTION_INDEX_FILES] != "":
		s += "File(s):\n\n"
		s += arr[AttibutionIndex.ATTRIBUTION_INDEX_FILES]
	
	return s
