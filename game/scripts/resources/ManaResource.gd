extends EntityResource
class_name ManaResource

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

var mana_regen : int = 10
var tickrate : float = 2
var timer : float = 0

var int_id : int = 0
var spirit_id = 0

func _init():
	should_process = true
	int_id = ESS.stat_get_id("Intellect")
	spirit_id = ESS.stat_get_id("Spirit")

func _ons_added(entity):
	refresh()

func _notification_sstat_changed(stat_id : int, value : float):
	if stat_id == int_id || stat_id == spirit_id:
		refresh()

func refresh():
	var intellect : int = owner.stat_gets_current(int_id)
	var spirit : int = owner.stat_gets_current(spirit_id)
	
	var m : bool = false
	
	if max_value == current_value:
		m = true
	
	var nv : int = int(intellect) * 10
	
	max_value = nv
	
	if m:
		current_value = nv
	
	mana_regen = int(spirit)

func _process_server(delta):
	timer += delta
	
	if timer > tickrate:
		timer -= tickrate
		
		if current_value < max_value:
			current_value += mana_regen

			if current_value > max_value:
				current_value = max_value
