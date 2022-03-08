tool
extends Popup

signal updated(value)

func init(value, graph_node, undo_redo) -> void:
	$Panel/Control.set_undo_redo(undo_redo)
	$Panel/Control.graph_node = graph_node
	$Panel/Control.set_value(value)

func _on_Control_updated(value) -> void:
	emit_signal("updated", value)

func _on_GradientPopup_popup_hide() -> void:
	queue_free()
