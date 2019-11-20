extends UnitFrame

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (PackedScene) var aura_entry_scene : PackedScene

export (NodePath) var name_text_path : NodePath
export (NodePath) var health_range_path : NodePath
export (NodePath) var aura_grid_path : NodePath

var name_text : Label
var health_range : Range
var aura_grid : GridContainer

var player : Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_text = get_node(name_text_path) as Label
	health_range = get_node(health_range_path) as Range
	aura_grid = get_node(aura_grid_path) as GridContainer

func set_player(p_player : Entity) -> void:
	if not player == null and is_instance_valid(player):
		player.get_health().disconnect("c_changed", self, "_on_player_health_changed")
		player.disconnect("caura_added", self, "on_caura_added")
		player.disconnect("caura_removed", self, "on_caura_removed")
		player.disconnect("cdied", self, "cdied")
		
		for a in aura_grid.get_children():
			aura_grid.remove_child(a)
			a.queue_free();
		
		player = null
		set_process(false)
	
	if p_player == null:
		hide()
		return
		
	player = p_player
	
	for index in range(player.cget_aura_count()):
		var aura : AuraData = player.cget_aura(index)
		
		on_caura_added(aura)
		
	
	player.connect("caura_added", self, "on_caura_added")
	player.connect("caura_removed", self, "on_caura_removed")
	player.connect("cdied", self, "cdied")
	
	var health = player.get_health()
	_on_player_health_changed(health)
	health.connect("c_changed", self, "_on_player_health_changed")
	
	name_text.text = player.centity_name
	
	set_process(true)
	show()

func on_caura_added(aura_data : AuraData) -> void:
	var created_node : Node = aura_entry_scene.instance()
	
	aura_grid.add_child(created_node)
	created_node.owner = aura_grid
	
	created_node.set_aura_data(aura_data)
	
func on_caura_removed(aura_data : AuraData) -> void:
	for bn in aura_grid.get_children():
		if bn.get_aura_data() == aura_data:
			aura_grid.remove_child(bn)
			bn.queue_free()
			return
	
func _on_player_health_changed(health : Stat) -> void:
	if health.cmax == 0:
		health_range.min_value = 0
		health_range.max_value = 1
		health_range.value = 0
		return
	
	health_range.min_value = 0
	health_range.max_value = health.cmax
	health_range.value = health.ccurrent
	
func cdied(entity : Entity) -> void:
	set_player(null)
