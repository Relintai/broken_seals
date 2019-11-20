extends MarginContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var progress_bar_path
export (NodePath) var label_path

var progress_bar : ProgressBar
var label : Label

var player : Entity = null
var spell_cast_info : SpellCastInfo = null

func _ready() -> void:
	progress_bar = get_node(progress_bar_path)
	progress_bar.min_value = 0
	label = get_node(label_path)
	hide()
	set_process(false)

func _process(delta: float) -> void:
	if not spell_cast_info.is_casting:
		hide()
		set_process(false)
		
	progress_bar.value = spell_cast_info.current_cast_time
	

func set_player(p_player: Entity) -> void:
	if not player == null:
		player.disconnect("ccast_started", self, "_ccast_started")
		player.disconnect("ccast_failed", self, "_ccast_failed")
		player.disconnect("ccast_finished", self, "_ccast_finished")
		player.disconnect("ccast_interrupted", self, "_ccast_interrupted")
		
	player = p_player
	
	player.connect("ccast_started", self, "_ccast_started")
	player.connect("ccast_failed", self, "_ccast_failed")
	player.connect("ccast_finished", self, "_ccast_finished")
	player.connect("ccast_interrupted", self, "_ccast_interrupted")
	
	
func _ccast_started(pspell_cast_info: SpellCastInfo) -> void:
	set_process(true)
	
	
	spell_cast_info = pspell_cast_info
	
	label.text = spell_cast_info.spell.get_name()
	
	progress_bar.value = spell_cast_info.current_cast_time
	progress_bar.max_value = spell_cast_info.cast_time
	
	show()
	
	
func _ccast_failed(pspell_cast_info: SpellCastInfo) -> void:
	set_process(false)
	hide()
	
func _ccast_finished(pspell_cast_info: SpellCastInfo) -> void:
	set_process(false)
	hide()
	
func _ccast_interrupted(pspell_cast_info: SpellCastInfo) -> void:
	set_process(false)
	hide()
	
	
	
	
