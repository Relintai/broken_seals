extends TextureMerger

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#func _texture_added(texture):
#	print("added")
#
#func _texture_removed():
#	print("removed")

func _texture_merged():
	$Sprite.texture = get_generated_texture(0)
