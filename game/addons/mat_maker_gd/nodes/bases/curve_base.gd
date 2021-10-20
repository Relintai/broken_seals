tool
extends MMNode

class Point:
	var p : Vector2
	var ls : float
	var rs : float
	func _init(x : float, y : float, nls : float, nrs : float) -> void:
		p = Vector2(x, y)
		ls = nls
		rs = nrs

var points = [ Point.new(0.0, 0.0, 0.0, 1.0), Point.new(1.0, 1.0, 1.0, 0.0) ]

func to_string() -> String:
	var rv = PoolStringArray()
	for p in points:
		rv.append("("+str(p.x)+","+str(p.y)+","+str(p.ls)+","+str(p.rs)+")")
		
	return rv.join(",")

func clear() -> void:
	points.clear()
	curve_changed()

func add_point(x : float, y : float, ls : float = INF, rs : float = INF) -> void:
	for i in points.size():
		if x < points[i].p.x:
			if ls == INF:
				ls == 0
			if rs == INF:
				rs == 0
				
			points.insert(i, Point.new(x, y, ls, rs))
			curve_changed()
			return
			
	points.append(Point.new(x, y, ls, rs))
	curve_changed()

func remove_point(index : int) -> bool:
	if index <= 0 or index >= points.size() - 1:
		return false
	else:
		points.remove(index)
		curve_changed()
	return true

func get_point_count() -> int:
	return points.size()

func set_point(i : int, v : Point) -> void:
	points[i] = v
	curve_changed()

func set_poins(v : PoolRealArray) -> void:
	#points[i] = v
	curve_changed()

func curve_changed() -> void:
	_curve_changed()

func _curve_changed() -> void:
	emit_changed()
