extends KinematicBody

func _enter_tree():
	var spat : Node = get_parent()
	
	while spat != null:
		if spat is Spatial:
			transform = (spat as Spatial).transform * transform
		
		spat = spat.get_parent()
		
		

