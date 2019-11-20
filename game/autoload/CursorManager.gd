extends Node

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(Texture) var default_cursor : Texture
export(Texture) var loot_cursor : Texture
export(Texture) var attack_cursor : Texture
export(Texture) var speak_cursor : Texture
export(Texture) var drag_drop_cursor : Texture
export(Texture) var forbidden_cursor : Texture
export(Texture) var text_cursor : Texture
export(Vector2) var text_cursor_hotspot : Vector2

func _ready():
    # Changes only the arrow shape of the cursor.
    # This is similar to changing it in the project settings.
    Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW)
    Input.set_custom_mouse_cursor(attack_cursor, Input.CURSOR_MOVE)
    Input.set_custom_mouse_cursor(loot_cursor, Input.CURSOR_CROSS)
    Input.set_custom_mouse_cursor(speak_cursor, Input.CURSOR_HELP)
    Input.set_custom_mouse_cursor(drag_drop_cursor, Input.CURSOR_CAN_DROP)
    Input.set_custom_mouse_cursor(forbidden_cursor, Input.CURSOR_FORBIDDEN)
    Input.set_custom_mouse_cursor(text_cursor, Input.CURSOR_IBEAM, text_cursor_hotspot)

    # Changes a specific shape of the cursor (here, the I-beam shape).
#    Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
