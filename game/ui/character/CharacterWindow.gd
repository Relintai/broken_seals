extends Control

#export(NodePath) var opener_button_path : NodePath
var opener_button : BaseButton

export(NodePath) var container_path : NodePath
var container : Node

var _player : Entity

func _ready():
#	opener_button = get_node_or_null(opener_button_path) as BaseButton
	container = get_node(container_path)

func set_player(p_player: Entity) -> void:
	_player = p_player
	
	for c in container.get_children():
		if c.has_method("set_player"):
			c.set_player(_player)

func _on_button_toggled(button_pressed):
	if button_pressed:
		show()
	else:
		hide()


func _on_Button_pressed():
	if opener_button:
		opener_button.pressed = false
		
	hide()
