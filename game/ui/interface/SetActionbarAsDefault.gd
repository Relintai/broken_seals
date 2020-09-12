extends Button

var _player : Entity

func set_player(p_player: Entity) -> void:
	_player = p_player

func _pressed():
	if _player && is_instance_valid(_player):
		var abp : ActionBarProfile = _player.get_action_bar_profile()
		
		var cp : ClassProfile = ProfileManager.getc_player_profile().get_class_profile(_player.gets_entity_data().get_path())
		
		cp.get_default_action_bar_profile().from_actionbar_profile(abp)
		
		ProfileManager.save()
