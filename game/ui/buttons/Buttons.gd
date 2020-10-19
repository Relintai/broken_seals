extends Control

# Copyright (c) 2019-2020 Péter Magyar
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

export (PackedScene) var image_button : PackedScene

export (NodePath) var spell_book_path
export (NodePath) var spell_book_button_path
var spell_book
var spell_book_button

export (NodePath) var lock_button_path
var lock_button

var player : Entity

func _ready():
	lock_button = get_node(lock_button_path)
	lock_button.connect("pressed", self, "_lock_button_click")

func add_image_button(texture : Texture, index : int  = -1) -> Button:
	var button : Button = image_button.instance() as Button
	
	button.set_meta("button_index", index)
	
	button.get_child(0).texture = texture
	
	add_child(button)
	
	for ch in get_children():
		var button_index : int = get_child_count()
		
		if ch.has_meta("button_index"):
			button_index = ch.get_meta("button_index")

		if button_index != -1:
			move_child(ch, button_index)
	
	return button

func set_player(p_player):
	player = p_player

		
func _lock_button_click():
	if player == null:
		return
	
	var cls = player.centity_data
		
	if cls == null:
		return
		
	var profile = ProfileManager.getc_player_profile().get_class_profile(cls.resource_path)
	
	profile.actionbar_locked = not profile.actionbar_locked
	
