extends PanelContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var item_entry_scene : PackedScene
export(PackedScene) var recipe_selector_scene : PackedScene

export(NodePath) var item_container_path : NodePath
export(NodePath) var tools_container_path : NodePath
export(NodePath) var materials_container_path : NodePath
export(NodePath) var recipe_selector_container_path : NodePath

export(NodePath) var recipe_selector_main_on : NodePath
export(NodePath) var recipe_selector_main_off : NodePath
export(NodePath) var materials_container_main_on : NodePath
export(NodePath) var materials_container_main_off : NodePath

var _item_container : Node
var _tools_container : Node
var _materials_container : Node
var _recipe_selector_container : Node

var _selected_craft_recipe : CraftRecipe

var _player : Entity

var _recipe_selector_main_on : Node
var _recipe_selector_main_off : Node
var _materials_container_main_on : Node
var _materials_container_main_off : Node

func _ready():
	_item_container = get_node(item_container_path)
	_tools_container = get_node(tools_container_path)
	_materials_container = get_node(materials_container_path)
	_recipe_selector_container = get_node(recipe_selector_container_path)
	
	_recipe_selector_main_on = get_node(recipe_selector_main_on)
	_recipe_selector_main_off = get_node(recipe_selector_main_off)
	_materials_container_main_on = get_node(materials_container_main_on)
	_materials_container_main_off = get_node(materials_container_main_off)

func set_player(entity: Entity) -> void:
	_player = entity
	
	set_category(CraftRecipe.CRAFT_CATEGORY_ALCHEMY)

func set_category(category: int) -> void:
	for ch in _recipe_selector_container.get_children():
		ch.queue_free()
	
	var count : int = 0
	for i in range(_player.gets_craft_recipe_count()):
		var cr : CraftRecipe = _player.gets_craft_recipe(i)
		
		if cr.category == category:
			var rss : Node = recipe_selector_scene.instance()
			_recipe_selector_container.add_child(rss)
			rss.owner = _recipe_selector_container
			
			rss.set_recipe(cr, self)
			
			count += 1
			
	if count == 0:
		_recipe_selector_main_on.visible = false
		_recipe_selector_main_off.visible = true
	else:
		_recipe_selector_main_on.visible = true
		_recipe_selector_main_off.visible = false
		

func request_craft() -> void:
	_player.crequest_craft(_selected_craft_recipe.id)
	
	for ch in _tools_container.get_children():
		ch.refresh()
	
	for ch in _materials_container.get_children():
		ch.refresh()

func select_recipe(recipe : CraftRecipe) -> void:
	_selected_craft_recipe = recipe
	
	if _selected_craft_recipe == null:
		_materials_container_main_on.visible = false
		_materials_container_main_off.visible = true
		
		return
	else:
		_materials_container_main_on.visible = true
		_materials_container_main_off.visible = false
	
	_item_container.set_item(recipe.item)
	
	for ch in _tools_container.get_children():
		ch.queue_free()
	
	for ch in _materials_container.get_children():
		ch.queue_free()
	
	for i in range(recipe.get_required_tools_count()):
		var ih : CraftRecipeHelper = recipe.get_required_tool(i)
		
		if ih == null:
			continue
		
		var ie : Node = item_entry_scene.instance()
		_tools_container.add_child(ie)
		ie.owner = _tools_container
		ie.set_item(_player, ih)
		
	for i in range(recipe.get_required_materials_count()):
		var ih : CraftRecipeHelper = recipe.get_required_material(i)
		
		if ih == null:
			continue
		
		var ie : Node = item_entry_scene.instance()
		_materials_container.add_child(ie)
		ie.owner = _materials_container
		ie.set_item(_player, ih)
