extends EntityResource
class_name HealthResource

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

var stamina_stat_id : int = 0
var health_stat_id = 0

func _init():
	current_value = 100
	stamina_stat_id = ESS.stat_get_id("Stamina")
	health_stat_id = ESS.stat_get_id("Health")

func _ons_added(entity):
	refresh()

func _notification_sstat_changed(stat_id : int, value : float):
	if stat_id == stamina_stat_id || stat_id == health_stat_id:
		refresh()

func refresh():
	var stamina : int = owner.stat_gets_current(stamina_stat_id)
	var health : int = owner.stat_gets_current(health_stat_id)
	
	max_value = int(stamina) * 10 + int(health)
	#todo fix this if this solution works well
	current_value = max_value


