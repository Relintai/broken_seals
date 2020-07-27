extends PanelContainer

export(NodePath) var opener_button_path : NodePath
var opener_button : BaseButton

func _ready():
	opener_button = get_node_or_null(opener_button_path) as BaseButton


func _on_CharacterButton_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()


func _on_Button_pressed():
	if opener_button:
		opener_button.pressed = false
		
	hide()
