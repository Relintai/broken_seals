tool
extends Node

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

export(bool) var create = false setget createf
export(bool) var delete = false setget deletef


func createf(value : bool) -> void:
	if not value:
		return
	
	for i in range(6):
		for j in range(12):
			var actionstr : String = "input/actionbar_" + str(i) + "_" + str(j)
			
			var action : Dictionary = Dictionary()
			action["events"] = Array()
			action["deadzone"] = 0.5

			ProjectSettings.set(name, actionstr)
			ProjectSettings.save()

	
func deletef(value : bool) -> void:
	if not value:
		return
		
	for i in range(6):
		for j in range(12):
			var action : String = "input/actionbar_" + str(i) + "_" + str(j)
			
			ProjectSettings.clear(action)
			ProjectSettings.save()
