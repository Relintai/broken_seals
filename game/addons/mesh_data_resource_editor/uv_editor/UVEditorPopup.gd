tool
extends ConfirmationDialog

func _enter_tree():
	connect("confirmed", self, "on_ok_pressed")
	get_cancel().connect("pressed", self, "on_cancel_pressed")
	
func on_ok_pressed() -> void:
	$UVEditor.ok_pressed()

func on_cancel_pressed() -> void:
	$UVEditor.cancel_pressed()
