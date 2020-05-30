tool
extends Button

export(int) var tab = 0

var _panel

func _pressed():
	_panel.set_tab(tab)

func set_main_panel(panel):
	_panel = panel
