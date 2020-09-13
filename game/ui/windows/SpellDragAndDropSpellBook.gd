extends Button

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

var item : VendorItemDataEntry

func set_item(p_item):
	item = p_item
		
func get_drag_data(pos):
	if item == null || item.item:
		return null
	
	var tr = TextureRect.new()
	tr.texture = item.item.icon
	tr.expand = true
	
#	tr.rect_size = rect_size
	tr.rect_size = Vector2(45, 45)
	set_drag_preview(tr)

	var esd = ESDragAndDrop.new()
	
	esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_ITEM
	esd.item_path = item.item.resource_path

	return esd
