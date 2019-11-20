extends HBoxContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func set_player(player : Entity, spec : CharacterSpec, spec_index: int, row : int) -> void:
	for ch in get_children():
		ch.set_player(player, spec, spec_index, row)
