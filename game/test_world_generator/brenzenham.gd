tool
extends Reference

func draw_line(x0 : int, y0 : int, x1 : int, y1 : int, image : Image, color : Color) -> void:
	image.lock()
	
	if abs(y1 - y0) < abs(x1 - x0):
		brenzenham_line_low(x0, y0, x1, y1, image, color)
	else:
		brenzenham_line_high(x0, y0, x1, y1, image, color)
		
	image.unlock()

func brenzenham_line_low(x0 : int, y0 : int, x1 : int, y1 : int, image : Image, color : Color) -> void:
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var yi : int = 1
	
	if dy < 0:
		yi = - 1
		dy = - dy

	var D : int = 2 * dy - dx
	var y : int = y0

	for x in range(x0, x1):
		image.set_pixel(x, y, color)
		
		if D > 0:
			y = y + yi
			D = D - 2 * dx

		D = D + 2 * dy
		
func brenzenham_line_high(x0 : int, y0 : int, x1 : int, y1 : int, image : Image, color : Color) -> void:
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var xi : int = 1
	
	if dx < 0:
		xi = -1
		dx = -dx

	var D : int = 2 * dx - dy
	var x : int = x0

	for y in range(y0, y1):
		image.set_pixel(x, y, color)

		if D > 0:
			x = x + xi
			D = D - 2 * dy

		D = D + 2 * dx
		
