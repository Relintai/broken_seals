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
