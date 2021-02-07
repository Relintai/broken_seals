tool
extends MenuButton

var skeleton : Skeleton = null

func edit(new_skeleton : Skeleton):
	skeleton = new_skeleton
	
	# update our menu
	var popup = get_popup()
	if popup:
		popup.clear()
		
		if skeleton:
			for idx in range(0, skeleton.get_bone_count()):
				var parent = skeleton.get_bone_parent(idx)
				if parent != -1:
					var name = skeleton.get_bone_name(idx)
					popup.add_item(name, idx)

func select_bone(id):
	print("select bone " + str(id))
	
	var gizmo : BoneSpatialGizmo = skeleton.gizmo
	if gizmo:
		gizmo.set_selected_bone(id)
		skeleton.update_gizmo()

func _ready():
	var popup = get_popup()
	if popup:
		popup.connect("id_pressed", self, "select_bone")
