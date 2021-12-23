tool
extends PanelContainer

func _init():
#	Control/EditorZoomWidget
	pass

func set_edited_resource(res : WorldGenBaseResource):
	$ScrollContainer/MarginContainer/RectView.set_edited_resource(res)
