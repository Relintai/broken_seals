tool
extends HBoxContainer

#This is a port of godot 4.0's EditorZoomWidget

#/*************************************************************************/
#/* Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.                 */
#/* Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).   */
#/*                                                                       */
#/* Permission is hereby granted, free of charge, to any person obtaining */
#/* a copy of this software and associated documentation files (the       */
#/* "Software"), to deal in the Software without restriction, including   */
#/* without limitation the rights to use, copy, modify, merge, publish,   */
#/* distribute, sublicense, and/or sell copies of the Software, and to    */
#/* permit persons to whom the Software is furnished to do so, subject to */
#/* the following conditions:                                             */
#/*                                                                       */
#/* The above copyright notice and this permission notice shall be        */
#/* included in all copies or substantial portions of the Software.       */
#/*                                                                       */
#/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
#/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
#/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
#/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
#/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
#/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
#/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
#/*************************************************************************/

var zoom_minus : Button
var zoom_reset : Button
var zoom_plus : Button

var EDSCALE : float = 1

export(float) var zoom : float = 1.0 setget set_zoom, get_zoom

signal zoom_changed(zoom)

func _init() -> void:
	# Zoom buttons
	zoom_minus = Button.new()
	zoom_minus.set_flat(true)
	add_child(zoom_minus)
	zoom_minus.connect("pressed", self, "_button_zoom_minus")
	zoom_minus.set_shortcut(ED_SHORTCUT("canvas_item_editor/zoom_minus", tr("Zoom Out"), KEY_MASK_CMD | KEY_MINUS))
	zoom_minus.set_focus_mode(FOCUS_NONE)

	zoom_reset = Button.new()
	zoom_reset.set_flat(true)
	add_child(zoom_reset)
	zoom_reset.add_constant_override("outline_size", 1)
	zoom_reset.add_color_override("font_outline_color", Color(0, 0, 0))
	zoom_reset.add_color_override("font_color", Color(1, 1, 1))
	zoom_reset.connect("pressed", self, "_button_zoom_reset")
	zoom_reset.set_shortcut(ED_SHORTCUT("canvas_item_editor/zoom_reset", tr("Zoom Reset"), KEY_MASK_CMD | KEY_0))
	zoom_reset.set_focus_mode(FOCUS_NONE)
	#Prevent the button's size from changing when the text size changes
	zoom_reset.set_custom_minimum_size(Vector2(75, 0))

	zoom_plus = Button.new()
	zoom_plus.set_flat(true)
	add_child(zoom_plus)
	zoom_plus.connect("pressed", self, "_button_zoom_plus")
	zoom_plus.set_shortcut(ED_SHORTCUT("canvas_item_editor/zoom_plus", tr("Zoom In"), KEY_MASK_CMD | KEY_EQUAL)) # Usually direct access key for PLUS
	zoom_plus.set_focus_mode(FOCUS_NONE)

	_update_zoom_label()
	
	add_constant_override("separation", round(-8))

func get_zoom() -> float:
	return zoom

func set_zoom(p_zoom : float) -> void:
	if (p_zoom > 0 && p_zoom != zoom):
		zoom = p_zoom;
		_update_zoom_label();

func set_zoom_by_increments(p_increment_count : int, p_integer_only : bool) -> void:
	# Remove editor scale from the index computation.
	var zoom_noscale : float = zoom / max(1, EDSCALE)
	var CMP_EPSILON : float = 0.00001

	if (p_integer_only):
		# Only visit integer scaling factors above 100%, and fractions with an integer denominator below 100%
		# (1/2 = 50%, 1/3 = 33.33%, 1/4 = 25%, …).
		# This is useful when working on pixel art projects to avoid distortion.
		# This algorithm is designed to handle fractional start zoom values correctly
		# (e.g. 190% will zoom up to 200% and down to 100%).
		if (zoom_noscale + p_increment_count * 0.001 >= 1.0 - CMP_EPSILON):
			# New zoom is certain to be above 100%.
			if (p_increment_count >= 1):
				# Zooming.
				set_zoom(floor(zoom_noscale + p_increment_count) * max(1, EDSCALE))
			else:
				# Dezooming.
				set_zoom(ceil(zoom_noscale + p_increment_count) * max(1, EDSCALE))
		else:
			if (p_increment_count >= 1):
				# Zooming. Convert the current zoom into a denominator.
				var new_zoom : float = 1.0 / ceil(1.0 / zoom_noscale - p_increment_count)
				if (is_equal_approx(zoom_noscale, new_zoom)):
					# New zoom is identical to the old zoom, so try again.
					# This can happen due to floating-point precision issues.
					new_zoom = 1.0 / ceil(1.0 / zoom_noscale - p_increment_count - 1)
					
				set_zoom(new_zoom * max(1, EDSCALE));
			else:
				# Dezooming. Convert the current zoom into a denominator.
				var new_zoom : float = 1.0 / floor(1.0 / zoom_noscale - p_increment_count)
				if (is_equal_approx(zoom_noscale, new_zoom)):
					# New zoom is identical to the old zoom, so try again.
					# This can happen due to floating-point precision issues.
					new_zoom = 1.0 / floor(1.0 / zoom_noscale - p_increment_count + 1)
					
				set_zoom(new_zoom * max(1, EDSCALE))
	else:
		# Base increment factor defined as the twelveth root of two.
		# This allow a smooth geometric evolution of the zoom, with the advantage of
		# visiting all integer power of two scale factors.
		# note: this is analogous to the 'semitones' interval in the music world
		# In order to avoid numerical imprecisions, we compute and edit a zoom index
		# with the following relation: zoom = 2 ^ (index / 12)

		if (zoom < CMP_EPSILON || p_increment_count == 0):
			return

		# zoom = 2**(index/12) => log2(zoom) = index/12
		var closest_zoom_index : float = round(log(zoom_noscale) * 12.0 / log(2.0))

		var new_zoom_index : float = closest_zoom_index + p_increment_count
		var new_zoom : float = pow(2.0, new_zoom_index / 12.0)

		# Restore Editor scale transformation
		new_zoom *= max(1, EDSCALE)

		set_zoom(new_zoom)


func _update_zoom_label() -> void:
	var zoom_text : String = ""
	
	# The zoom level displayed is relative to the editor scale
	# (like in most image editors). Its lower bound is clamped to 1 as some people
	# lower the editor scale to increase the available real estate,
	# even if their display doesn't have a particularly low DPI.
	
	if (zoom >= 10):
		# Don't show a decimal when the zoom level is higher than 1000 %.
		#zoom_text = (rtos(round((zoom / max(1, EDSCALE)) * 100))) + " %"
		zoom_text = (String(round((zoom / max(1, EDSCALE)) * 100))) + " %"
	else:
		var v : float = (zoom / max(1, EDSCALE)) * 100
		var val : float =  floor(v / 0.1 + 0.5) * 0.1

#		zoom_text = (rtos(val)) + " %"
		zoom_text = (String(val)) + " %"

	zoom_reset.set_text(zoom_text)

func _button_zoom_minus() -> void:
	set_zoom_by_increments(-6, Input.is_key_pressed(KEY_ALT));
	emit_signal("zoom_changed", zoom);

func _button_zoom_reset() -> void:
	set_zoom(1.0 * max(1, EDSCALE));
	emit_signal("zoom_changed", zoom);

func _button_zoom_plus() -> void:
	set_zoom_by_increments(6, Input.is_key_pressed(KEY_ALT));
	emit_signal("zoom_changed", zoom);

func _notification(p_what : int) -> void:
	if (p_what == NOTIFICATION_ENTER_TREE || p_what == NOTIFICATION_THEME_CHANGED):
		zoom_minus.icon = get_icon("ZoomLess", "EditorIcons")
		zoom_plus.icon = get_icon("ZoomMore", "EditorIcons")

#from godot editor/editor_Settings.cpp
func ED_SHORTCUT(p_path : String, p_name : String, p_keycode : int, editor_settings : EditorSettings = null) -> ShortCut:
	if OS.get_name() == "OSX":
		# Use Cmd+Backspace as a general replacement for Delete shortcuts on macOS
		if (p_keycode == KEY_DELETE):
			p_keycode = KEY_MASK_CMD | KEY_BACKSPACE

	var ie : InputEventKey = null
	if (p_keycode):
		ie = InputEventKey.new()

		ie.set_unicode(p_keycode & KEY_CODE_MASK)
		ie.set_scancode(p_keycode & KEY_CODE_MASK)
		ie.set_shift(bool(p_keycode & KEY_MASK_SHIFT))
		ie.set_alt(bool(p_keycode & KEY_MASK_ALT))
		ie.set_control(bool(p_keycode & KEY_MASK_CTRL))
		ie.set_metakey(bool(p_keycode & KEY_MASK_META))

	if (!editor_settings):
		var sc : ShortCut
		sc = ShortCut.new()
		sc.set_name(p_name)
		sc.set_shortcut(ie)
		sc.set_meta("original", ie)
		return sc

	var sc : ShortCut = editor_settings.get_shortcut(p_path)
	if (sc.is_valid()):
		sc.set_name(p_name); #keep name (the ones that come from disk have no name)
		sc.set_meta("original", ie); #to compare against changes
		return sc;

	sc = ShortCut.new()
	sc.set_name(p_name)
	sc.set_shortcut(ie)
	sc.set_meta("original", ie) #to compare against changes
	editor_settings.add_shortcut(p_path, sc)

	return sc

