extends PanelContainer

export(NodePath) var actionbar_set_default_button_path : NodePath

func set_player(p_player: Entity) -> void:
	get_node(actionbar_set_default_button_path).set_player(p_player)
