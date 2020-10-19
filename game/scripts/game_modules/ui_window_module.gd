extends GameModule
class_name UIWindowModule

export(PackedScene) var scene : PackedScene
export(Texture) var opener_button_texture : Texture
export(int) var index : int = -1
export(bool) var add_button : bool = true

func on_request_instance(what : int, node : Node) -> void:
	if what == DataManager.PLAYER_UI_INSTANCE:
		var sc = scene.instance()
		
		node.windows.add_child(sc)
		
		if add_button:
			var b = node.buttons.add_image_button(opener_button_texture, index)
			
			b.connect("toggled", sc, "_on_button_toggled")
			sc.opener_button = b
		
		sc.hide()
		
