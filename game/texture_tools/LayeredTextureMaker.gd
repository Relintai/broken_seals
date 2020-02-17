tool
extends Node2D
class_name LayeredTextureMaker

export(Vector2) var texture_size = Vector2(16, 16) setget set_tex_size
export(String) var texture_name = ""

export(float) var refresh_rate : float = 2.0
export(bool) var save : bool = false setget save_set

var preview_node : Sprite = null
var viewport : Viewport = null

var last_refresh : float = 0

func _enter_tree():
	set_meta("_edit_lock_", true)
	emit_signal("item_lock_status_changed")
	create_preview()
	
func create_preview():
	for c in get_children():
		if c.name == "Preview":
			preview_node = c
			
			for ch in preview_node.get_children():
				if ch is Viewport:
					viewport = ch as Viewport
					break
				
			break

	if viewport != null:
		viewport.queue_free()
		
	if preview_node != null:
		preview_node.queue_free()
		
		
	preview_node = Sprite.new() as Sprite
	preview_node.name = "Preview"
	preview_node.centered = false
	add_child(preview_node)
		
	#don't, so it won't show up in the inspector
	#if Engine.editor_hint:
	#	preview_node.owner = get_tree().edited_scene_root
	
	viewport = Viewport.new()
	preview_node.add_child(viewport)
	
	#don't, so it won't show up in the inspector
	#if Engine.editor_hint:
	#	viewport.owner = get_tree().edited_scene_root
		
	viewport.set_vflip(true)
	viewport.set_size(texture_size)
	preview_node.set_texture(null)
	preview_node.set_texture(viewport.get_texture())
	
	set_process(true)

func _process(delta):
	#not the best solution, but works for now
	last_refresh += delta
	
	if (last_refresh > refresh_rate):
		last_refresh -= refresh_rate
		
		for ch in viewport.get_children():
			ch.queue_free()
			
		for ch in get_children():
			viewport.add_child(ch.duplicate())
			
		if get_children().has(preview_node) and get_child(get_child_count() - 1) != preview_node:
			move_child(preview_node, get_child_count() - 1)
			

func save() -> void:
	if texture_name == "":
		print("Set a name for your texture!")
		return
	
func preview_refresh() -> void:
	for ch in viewport.get_children():
		ch.queue_free()
		
	for ch in get_children():
		if ch.name == "Preview":
			continue
			
		viewport.add_child(ch.duplicate())

func set_tex_size(size : Vector2) -> void:
	texture_size = size
	
	create_preview()

func save_set(val):
	if val:
		save()
