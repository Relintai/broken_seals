extends GameModule
class_name UIWindowModule

export(PackedScene) var character_scene : PackedScene
export(Texture) var opener_button_texture : Texture

func on_request_instance(what : int, node : Node) -> void:
	if what == DataManager.PLAYER_UI_INSTANCE:
		var sc = character_scene.instance()
		
		node.windows.add_child(sc)
		var b = node.buttons.add_image_button(opener_button_texture, 0)
		
		b.connect("toggled", sc, "_on_button_toggled")
		sc.opener_button = b
		
		sc.hide()
		
