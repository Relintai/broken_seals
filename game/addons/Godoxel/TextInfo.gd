tool
extends Control

var size = 240

#TODO: To make reading the text easier, the text info with the longest text should have it's length applied to all the
#the other text infos

func add_text_info(text_name, custom_node = null):
	var last_text_info_child = null
	var child_count = get_child_count()
	if not child_count <= 0:
		last_text_info_child = get_children()[get_children().size() - 1]
	var label = Label.new()
	label.name = text_name
	label.rect_size = Vector2(size, 14)
	if not last_text_info_child == null:
		var x = last_text_info_child.rect_position.x
		var y = last_text_info_child.rect_position.y
		var temp_size = size
		if child_count == 4:
			x = 0
			y = 20
			temp_size = 0
		label.rect_position = Vector2(x + temp_size, y)
	if not custom_node == null:
		label.add_child(custom_node)
	add_child(label)

func update_text_info(text_name, text_value = null, node = null, node_target_value = null, node_value = null):
	var text_label = self.get_node(text_name)
	if text_label == null:
		return
	if not node == null:
		get_node(text_name).get_node(node).set(node_target_value, node_value)
	if text_value == null:
		text_label.text = "%s: %s" % [text_name, null]
	else:
		text_label.text = "%s: %s" % [text_name, String(text_value)]
