extends VBoxContainer

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
		player.disconnect("notification_ccast", self, "on_notification_ccast")
		
	player = p_player
	
	player.connect("notification_ccast", self, "on_notification_ccast")
	
	
func on_notification_ccast(what : int, pspell_cast_info: SpellCastInfo) -> void:
	if what == SpellEnums.NOTIFICATION_CAST_STARTED:
		set_process(true)
		
		spell_cast_info = pspell_cast_info
		
		label.text = spell_cast_info.spell.get_name()
		
		progress_bar.value = spell_cast_info.current_cast_time
		progress_bar.max_value = spell_cast_info.cast_time
		
		show()
	elif what == SpellEnums.NOTIFICATION_CAST_FAILED:
		set_process(false)
		hide()
	elif what == SpellEnums.NOTIFICATION_CAST_FINISHED:
		set_process(false)
		hide()
	elif what == SpellEnums.NOTIFICATION_CAST_INTERRUPTED:
		set_process(false)
		hide()
	
	
	
	
