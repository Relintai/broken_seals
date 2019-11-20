extends Label

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

func _process(delta):
	text = str(Engine.get_frames_per_second()) + "FPS"
