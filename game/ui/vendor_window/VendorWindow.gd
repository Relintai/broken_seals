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

export(NodePath) var opener_button_path : NodePath
var opener_button : BaseButton

export(NodePath) var spell_entry_container_path : NodePath
export(NodePath) var prev_button_path : NodePath
export(NodePath) var next_button_path : NodePath

export(bool) var show_not_learned : bool = true
export(bool) var show_not_learnable : bool = false

var _spell_entry_container : Node
var _item_entries : Array

var _prev_button : Button
var _next_button : Button

var _player : Entity

var _page : int = 0
var _max_pages : int = 0

var _vendor_item_data : VendorItemData

func _ready() -> void:
	opener_button = get_node_or_null(opener_button_path) as BaseButton
	
	_item_entries.clear()
	
	_spell_entry_container = get_node(spell_entry_container_path)

	for i in range(_spell_entry_container.get_child_count()):
		_item_entries.append(_spell_entry_container.get_child(i))
		
	_prev_button = get_node(prev_button_path)
	_next_button = get_node(next_button_path)
	
	_prev_button.connect("pressed", self, "dec_page")
	_next_button.connect("pressed", self, "inc_page")
		
	connect("visibility_changed", self, "_visibility_changed")

func inc_page() -> void:
	if _vendor_item_data == null:
		return
		
	_page += 1
	
	if _page > _max_pages:
		_page = _max_pages
	
	refresh_entries()
		
func dec_page() -> void:
	if _vendor_item_data == null:
		return
		
	_page -= 1
	
	if _page < 0:
		_page = 0
		
	refresh_entries()

func refresh_entries() -> void:
	if  _player == null || _vendor_item_data == null:
		return

	var i : int = 0
	var n : int = 0
#	for n in range(len(_item_entries)):
	while n < len(_item_entries):
		var spindex : int = i + (_page * len(_item_entries))

		if spindex >= _vendor_item_data.get_num_vendor_datas():
			_item_entries[n].set_vendor_item(_player, null, 0)
			i += 1
			n += 1
			continue
			
		var vide : VendorItemDataEntry = _vendor_item_data.get_vendor_data(spindex)
		
		if !vide:
			continue
		
		_item_entries[n].set_vendor_item(_player, vide, spindex)
		i += 1
		n += 1


func refresh_all() -> void:
	if _player == null:
		return

	if _vendor_item_data == null:
		return
		
	_max_pages = int(_vendor_item_data.get_num_vendor_datas() / len(_item_entries))

	if _page > _max_pages:
		_page = _max_pages

	refresh_entries()
	

func _visibility_changed() -> void:
	if visible:
		if !_player:
			return
			
		var t : Entity = _player.ctarget
		
		if !t:
			return
			
		_vendor_item_data = t.getc_entity_data().entity_class_data.get_vendor_item_data()

		_page = 0
		refresh_all()
		
		

func set_player(p_player: Entity) -> void:
	if _player != null:
		_player.disconnect("onc_open_winow_request", self, "onc_open_winow_request")
	
	_player = p_player
	
	_player.connect("onc_open_winow_request", self, "onc_open_winow_request")



func onc_open_winow_request(window_id : int) -> void:
	if window_id != EntityEnums.ENTITY_WINDOW_VENDOR:
		return
		
	show()

#	if player.has_signal("player_moved") && !player.is_connected("player_moved", self, "on_player_moved"):
#		player.connect("player_moved", self, "on_player_moved", [], CONNECT_ONESHOT)
