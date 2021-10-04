tool
extends MarginContainer

export(NodePath) var add_popup_path : NodePath = "Popups/AddPopup"



func _on_AddButton_pressed():
	get_node(add_popup_path).popup_centered()

func _on_AddPopup_ok_pressed(script_path : String):
	#print(script_path)
	pass
