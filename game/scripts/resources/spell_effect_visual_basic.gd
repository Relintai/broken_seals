extends SpellEffectVisual
class_name SpellEffectVisualBasic

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
