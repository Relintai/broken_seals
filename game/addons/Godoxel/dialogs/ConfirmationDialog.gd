extends ConfirmationDialog
tool

func _ready():
	yield(owner, "ready")
	find_node("Width").value = owner.paint_canvas.canvas_width
	find_node("Height").value = owner.paint_canvas.canvas_height


func _on_ConfirmationDialog_confirmed():
	var width = find_node("Width").value
	var height = find_node("Height").value
	print("change canvas size: ", width, " ", height)
	owner.paint_canvas.resize(width, height)


func _on_ChangeCanvasSize_visibility_changed():
	if visible:
		find_node("Width").value = owner.paint_canvas.canvas_width
		find_node("Height").value = owner.paint_canvas.canvas_height
