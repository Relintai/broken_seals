class_name BrushPrefabs


const list = [
	[   			Vector2(0, -1),
	Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0),
					Vector2(0, 1)
	],
	[Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
	Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0),
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1),
	],
	[
	Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0),
	],
	[   			Vector2(0, -1),
					Vector2(0, 0), 
					Vector2(0, 1)
	]
]


enum Type {
	V_LINE,
	H_LINE,
	RECT,
	CIRCLE,
}

static func get_brush(type, size: int):
	var pixels = []
	if size < 1:
		size = 1
	
	match type:
		Type.CIRCLE:
			size += 1
			var center = Vector2.ZERO
			var last = center
			var radius = size / 2.0
			for x in range(size):
				for y in range(size):
					if Vector2(x - radius, y - radius).length() < size / 3.0:
						pixels.append(Vector2(x, y))
						
			var avg = Vector2(size / 2, size / 2)
			avg = Vector2(floor(avg.x), floor(avg.y))
			
			for i in range(pixels.size()):
				pixels[i] -= avg
			
		Type.RECT:
			var center = Vector2.ZERO
			var last = center
			for x in range(size):
				for y in range(size):
					pixels.append(Vector2(x, y))
			
			var avg = Vector2.ZERO
			for cell in pixels:
				avg += cell
			
			avg.x /= pixels.size()
			avg.y /= pixels.size()
			
			avg = Vector2(floor(avg.x), floor(avg.y))
			
			for i in range(pixels.size()):
				pixels[i] -= avg
			
		Type.V_LINE:
			var center = Vector2.ZERO
			var last = center
			pixels.append(Vector2.ZERO)
			
			for i in range(size - 1):
				var sig = sign(last.y)
				if sig == 0:
					sig = 1
				
				if last.y < 0:
					center.y = abs(last.y) * -sig
				else:
					center.y = abs(last.y+1) * -sig
				last = center
				pixels.append(center)
		Type.H_LINE:
			var center = Vector2.ZERO
			var last = center
			pixels.append(Vector2.ZERO)
			
			for i in range(size - 1):
				var sig = sign(last.x)
				if sig == 0:
					sig = 1
				
				if last.x < 0:
					center.x = abs(last.x) * -sig
				else:
					center.x = abs(last.x+1) * -sig
				last = center
				pixels.append(center)
	
	return pixels


