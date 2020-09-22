extends GameModule
class_name UIGuiChildModule

export(PackedScene) var scene : PackedScene
export(bool) var hide : bool = false

func on_request_instance(what : int, node : Node) -> void:
	if what == DataManager.PLAYER_UI_INSTANCE:
		var sc = scene.instance()
		
		node.gui_base.add_child(sc)

		if hide:
			sc.hide()
		
