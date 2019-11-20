extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var _recipe : CraftRecipe
var _crafting_window : Node

func set_recipe(recipe : CraftRecipe, crafting_window : Node) -> void:
	_recipe = recipe
	_crafting_window = crafting_window
	
	text = recipe.item.item.text_name

func _pressed():
	_crafting_window.select_recipe(_recipe)
