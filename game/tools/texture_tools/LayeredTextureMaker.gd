tool
extends Node2D
class_name LayeredTextureMaker

# Copyright (c) 2020 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(Vector2) var texture_size : Vector2 = Vector2(16, 16) setget set_tex_size
export(Texture) var texture : Texture = null

export(float) var refresh_rate : float = 2.0
export(bool) var save : bool = false setget save_set

var preview_node : Sprite = null
var viewport : Viewport = null

var last_refresh : float = 0
var queued_save : bool = false

const DEBUG_TREE : bool = false

func _enter_tree():
	if not Engine.editor_hint:
		return
		
	set_meta("_edit_lock_", true)
	#emit_signal("item_lock_status_changed")
	create_preview()
	set_process(true)
	
func create_preview():
	for c in get_children():
		if c.name == "Preview":
			c.name = "------"
			c.queue_free()
			break
		
	preview_node = Sprite.new() as Sprite
	preview_node.name = "Preview"
	preview_node.centered = false
	add_child(preview_node)
		
	if Engine.editor_hint and DEBUG_TREE:
		preview_node.owner = get_tree().edited_scene_root
	
	viewport = Viewport.new()
	preview_node.add_child(viewport)
	
	if Engine.editor_hint and DEBUG_TREE:
		viewport.owner = get_tree().edited_scene_root
		
	viewport.set_vflip(true)
	viewport.set_size(texture_size)
	preview_node.set_texture(null)
	preview_node.set_texture(viewport.get_texture())
	
	set_process(true)

func _process(delta):
	if (queued_save):
		save()
	
	#not the best solution, but works for now
	last_refresh += delta
	
	if (last_refresh > refresh_rate):
		last_refresh -= refresh_rate
		
		for ch in viewport.get_children():
			ch.queue_free()
			
		for ch in get_children():
			if ch.name == "Preview":
				continue
			
			var n = ch.duplicate()
			viewport.add_child(n)
			
			if Engine.editor_hint and DEBUG_TREE:
				n.owner = get_tree().edited_scene_root
			
		if get_children().has(preview_node) and get_child(get_child_count() - 1) != preview_node:
			move_child(preview_node, get_child_count() - 1)
			
		#queued_save = true
			

func save() -> void:
	#queued_save = false
	
	if texture == null:
		#print("LayeredTextureMaker: Set a target texture!")
		return
		
	#texture.set_data(viewport.get_texture().get_data())
	viewport.get_texture().get_data().save_png(texture.resource_path)
#	texture.property_list_changed_notify()
	
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
