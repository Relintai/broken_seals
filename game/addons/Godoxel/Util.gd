tool
extends Node
class_name GEUtils


static func get_pixels_in_line(from: Vector2, to: Vector2):
	var dx = to[0] - from[0]
	var dy = to[1] - from[1]
	var nx = abs(dx)
	var ny = abs(dy)
	var signX = sign(dx)
	var signY = sign(dy)
	var p = from
	var points : Array = [p]

	var ix = 0
	var iy = 0

	while ix < nx || iy < ny:
		if (1 + (ix << 1)) * ny < (1 + (iy << 1)) * nx:
			p[0] += signX
			ix +=1
		else:
			p[1] += signY
			iy += 1
		points.append(p)
	return points


static func to_1D_v(p, w) -> int:
	return p.x + p.y * w


static func to_1D(x, y, w) -> int:
	return x + y * w


static func to_2D(idx, w) -> Vector2:
	var p = Vector2()
	p.x = int(idx) % int(w)
	p.y = int(idx / w)
	return p 



static func color_from_array(color_array):
	var r = color_array[0]
	var g = color_array[1]
	var b = color_array[2]
	var a = color_array[3]
	return Color(r, g, b, a)

static func random_color():
	return Color(randf(), randf(), randf())

static func random_color_alt():
	var rand = randi() % 6
	
	match rand:
		#red
		0:
			return Color.red
		#blue
		1:
			return Color.blue
		#green
		2:
			return Color.green
		#orange
		3:
			return Color.orange
		#yellow
		4:
			return Color.yellow
		#purple
		5:
			return Color.purple

static func get_line_string(file, number):
	return file.get_as_text().split("\n")[number - 1].strip_edges()

static func printv(variable):
	var stack = get_stack()[get_stack().size() - 1]
	var line = stack.line
	var source = stack.source
	var file = File.new()
	file.open(source, File.READ)
	var line_string = get_line_string(file, line)
	file.close()
	var left_p = line_string.find("(")
	var left_p_string = line_string.right(left_p + 1)
	var right_p = left_p_string.find(")")
	var variable_name = left_p_string.left(right_p)
	print("%s: %s" % [variable_name, variable])
