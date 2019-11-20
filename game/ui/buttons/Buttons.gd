extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
	
