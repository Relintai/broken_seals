tool
extends EditorSpatialGizmo

class_name BoneSpatialGizmo

var offset = 0.1
var handle_dist = 0.1 # Distance of gizmo to bone origin
var selected_bone = -1 # Bone we are animating

var is_posing = false
var start_pose = Transform()
var start_point = Vector2()

var handle_idx = Array() # Handles we've added

const handle_rot_x = -2
const handle_rot_y = -3
const handle_rot_z = -4

func set_selected_bone(idx):
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return

	if idx >= 0 and idx < skeleton.get_bone_count():
		selected_bone = idx
	else:
		selected_bone = -1

func get_handle_name(index):
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return "No skeleton"
	
	var idx = handle_idx[index]
	if idx == handle_rot_x:
		return "Rotate X"
	elif idx == handle_rot_y:
		return "Rotate Y"
	elif idx == handle_rot_z:
		return "Rotate Z"
	else:
		return "huh???"

func get_handle_value(index):
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return "No skeleton"
	
	var idx = handle_idx[index]
	if selected_bone >= 0:
		return skeleton.get_bone_pose(selected_bone)
	else:
		return "No selected bone"

func set_handle(index, camera, point):
	var idx = handle_idx[index]
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return "No skeleton"
	
	if !is_posing:
		start_point = point
		start_pose = skeleton.get_bone_pose(selected_bone)
		is_posing = true
		print("start posing " + str(start_pose))
		return
	
	var moved = point - start_point
	var distance = moved.x + moved.y
	
	# calculate our new transform (in local space)
	var new_pose : Transform = start_pose
	if idx == handle_rot_x:
		# rotate around X
		new_pose = new_pose.rotated(start_pose.basis.x.normalized(), distance * 0.01)
	elif idx == handle_rot_y:
		# rotate around Y
		new_pose = new_pose.rotated(start_pose.basis.y.normalized(), distance * 0.01)
	elif idx == handle_rot_z:
		# rotate around Z
		new_pose = new_pose.rotated(start_pose.basis.z.normalized(), distance * 0.01)
	
	skeleton.set_bone_pose(selected_bone, new_pose)
	skeleton.update_gizmo()

func commit_handle(index, restore, cancel = false):
	# var idx = handle_idx[index]
	
	print("Commit")
	is_posing = false
	
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return
	
	if selected_bone == -1:
		return
	
	if (cancel):
		skeleton.set_bone_pose(selected_bone, restore)

func redraw():
	clear()
	
	var skeleton : Skeleton = get_spatial_node()
	if !skeleton:
		return
	
	var lines_material = get_plugin().get_material("skeleton", self)
	var selected_material = get_plugin().get_material("selected", self)
	var handles_material = get_plugin().get_material("handles", self)
	var handles = PoolVector3Array()
	handle_idx.clear()
	
	# loop through our bones
	for idx in range(0, skeleton.get_bone_count()):
		var parent = skeleton.get_bone_parent(idx)
		if parent != -1:
			var lines = PoolVector3Array()
			var parent_transform = skeleton.get_bone_global_pose(parent)
			var bone_transform = skeleton.get_bone_global_pose(idx)
			
			var parent_pos = parent_transform.origin
			var bone_pos = bone_transform.origin
			var delta = bone_pos - parent_pos
			var length = delta.length()
			
			var p1 = parent_pos + (delta * offset) + parent_transform.basis.x * length * offset
			var p2 = parent_pos + (delta * offset) + parent_transform.basis.z * length * offset
			var p3 = parent_pos + (delta * offset) - parent_transform.basis.x * length * offset
			var p4 = parent_pos + (delta * offset) - parent_transform.basis.z * length * offset
			
			lines.push_back(parent_pos)
			lines.push_back(p1)
			lines.push_back(p1)
			lines.push_back(bone_pos)
			
			lines.push_back(parent_pos)
			lines.push_back(p2)
			lines.push_back(p2)
			lines.push_back(bone_pos)
			
			lines.push_back(parent_pos)
			lines.push_back(p3)
			lines.push_back(p3)
			lines.push_back(bone_pos)
			
			lines.push_back(parent_pos)
			lines.push_back(p4)
			lines.push_back(p4)
			lines.push_back(bone_pos)
			
			lines.push_back(p1)
			lines.push_back(p2)
			lines.push_back(p2)
			lines.push_back(p3)
			lines.push_back(p3)
			lines.push_back(p4)
			lines.push_back(p4)
			lines.push_back(p1)
			
			if parent == selected_bone:
				add_lines(lines, selected_material, false)
			else:
				add_lines(lines, lines_material, false)
			
			if idx == selected_bone:
				handles.push_back(bone_pos + bone_transform.basis.x * handle_dist)
				handle_idx.push_back(handle_rot_x)
				
				handles.push_back(bone_pos + bone_transform.basis.y * handle_dist)
				handle_idx.push_back(handle_rot_y)
				
				handles.push_back(bone_pos + bone_transform.basis.z * handle_dist)
				handle_idx.push_back(handle_rot_z)
	
	if handles.size() > 0:
		add_handles(handles, handles_material)
