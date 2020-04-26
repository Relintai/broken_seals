extends Button

# Copyright (c) 2019-2020 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(NodePath) var name_label_path : NodePath
export(NodePath) var class_label_path : NodePath
export(NodePath) var level_label_path : NodePath

var id : int
var file_name : String

var name_label : Label
var class_label : Label
var level_label : Label

var entity : Entity
var class_profile : ClassProfile

func _ready():
	name_label = get_node(name_label_path) as Label
	class_label = get_node(class_label_path) as Label
	level_label = get_node(level_label_path) as Label
	
	connect("visibility_changed", self, "on_visibility_changed")

func setup(pfile_name : String, name : String, cls_name : String, level : int, class_level : int, pentity : Entity) -> void:
	file_name = pfile_name
	name_label.text = name
	class_label.text = cls_name + " (lvl " + str(class_level) + ')'
	level_label.text = str(level)
	entity = pentity
	
func set_class_name(name : String, level : int, pclass_profile : ClassProfile) -> void:
	name_label.text = name
	level_label.text = str(level)
	class_profile = pclass_profile

func on_visibility_changed():
	if visible and class_profile != null:
		level_label.text = str(class_profile.level)
		
