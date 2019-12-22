extends Control

# Copyright (c) 2019 Péter Magyar
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

export (NodePath) var spell_book_path
export (NodePath) var spell_book_button_path
var spell_book
var spell_book_button

export (NodePath) var lock_button_path
var lock_button

var player 

func _ready():
	spell_book = get_node(spell_book_path)
	spell_book_button = get_node(spell_book_button_path)
	
	spell_book_button.connect("pressed", self, "_spell_book_click")
	
	lock_button = get_node(lock_button_path)
	lock_button.connect("pressed", self, "_lock_button_click")

func set_player(p_player):
	player = p_player

func _spell_book_click():
	if spell_book.visible:
		spell_book.hide()
	else:
		spell_book.show()
		
func _lock_button_click():
	if player == null:
		return
	
	var cls = player.centity_data
		
	if cls == null:
		return
		
	var profile = Profiles.get_class_profile(cls.id)
	
	profile.actionbar_locked = not profile.actionbar_locked
	
