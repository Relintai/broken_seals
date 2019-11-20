extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var name_label_path : NodePath
export(NodePath) var class_label_path : NodePath
export(NodePath) var level_label_path : NodePath

var id : int
var file_name : String
var name_label : Label
var class_label : Label
var level_label : Label
var entity : Entity

func _ready():
	name_label = get_node(name_label_path) as Label
	class_label = get_node(class_label_path) as Label
	level_label = get_node(level_label_path) as Label


func setup(pfile_name : String, name : String, cls_name : String, level : int, pentity : Entity) -> void:
	file_name = pfile_name
	name_label.text = name
	class_label.text = cls_name
	level_label.text = str(level)
	entity = pentity
	
func set_class_name(name : String) -> void:
	class_label.text = name
