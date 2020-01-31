extends SpellEffectVisual
class_name SpellEffectVisualBasic

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

export (PackedScene) var spell_cast_effect_left_hand : PackedScene
export (PackedScene) var spell_cast_effect_right_hand : PackedScene

export (PackedScene) var torso_aura_effect : PackedScene
export (float) var torso_aura_effect_time : float

export (PackedScene) var root_aura_effect : PackedScene
export (float) var root_aura_effect_time : float

export (PackedScene) var torso_spell_cast_finish_effect : PackedScene
export (float) var torso_spell_cast_finish_effect_time : float = 1

export (PackedScene) var root_spell_cast_finish_effect : PackedScene
export (float) var root_spell_cast_finish_effect_time : float = 1
