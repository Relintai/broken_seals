extends ItemTemplate
class_name ItemTemplateGD

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _create_item_instance():
	var ii : ItemInstance = ItemInstance.new()
	
	ii.item_template = self
	
	return ii
