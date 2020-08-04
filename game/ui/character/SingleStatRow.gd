extends HBoxContainer

export(String) var stat_name : String
var stat_id : int

onready var stat_name_label : Label = $StatName as Label
onready var stat_value_label : Label = $Stat as Label

var _player : Entity

func _ready():
	stat_id = ESS.stat_get_id(stat_name)
	
	stat_name_label.text = stat_name
	
	connect("visibility_changed", self, "on_visibility_changed")

func on_visibility_changed():
	if _player:
		stat_value_label.text = str(_player.stat_getc_current(stat_id)) + " "
	else:
		stat_value_label.text = str(0) + " "

func set_player(p_player: Entity) -> void:
	_player = p_player
	
	on_visibility_changed()

"""
Agility,Strength,Stamina,Intellect,Spirit,
Health,Mana,Speed,Global Cooldown,Haste,Haste Rating,
Resilience,Armor,Attack Power,Spell Power,Melee Crit,
Melee Crit Bonus,Spell Crit,Spell Crit Bonus,Block,Parry,Damage Reduction,
Melee Damage Reduction,Spell Damage Reduction,Damage Taken,Heal Taken,
Melee Damage,Spell Damage,Holy Resist,Shadow Resist,Nature Resist,
Fire Resist,Frost Resist,Lightning Resist,Chaos Resist,Silence Resist,Fear Resist,
Stun Resist,Energy,Rage,XP Rate,Weapon Damage Min,Weapon Damage Max
"""
