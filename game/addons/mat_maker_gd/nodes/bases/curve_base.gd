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

export(PoolRealArray) var points

func init_points_01():
	if points.size() == 0:
		points = [ 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0 ]

func init_points_11():
	if points.size() == 0:
		points = [ 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0 ]

func to_string() -> String:
	var rv = PoolStringArray()
	for p in points:
		rv.append("("+str(p.x)+","+str(p.y)+","+str(p.ls)+","+str(p.rs)+")")
		
	return rv.join(",")

func clear() -> void:
	points.clear()
	curve_changed()

func add_point(x : float, y : float, ls : float = INF, rs : float = INF) -> void:
	var indx : int = points.size() / 4
	
	for i in indx:
		var ii : int = i * 4
		if x < points[ii]:
			if ls == INF:
				ls == 0
			if rs == INF:
				rs == 0
				
			points.insert(ii, x)
			points.insert(ii + 1, y)
			points.insert(ii + 2, ls)
			points.insert(ii + 3, rs)
			
			curve_changed()
			return
			
	points.append(x)
	points.append(y)
	points.append(ls)
	points.append(rs)
	
	curve_changed()

func remove_point(i : int) -> bool:
	var index : int = i * 4
	
	if index <= 0 or index >= points.size() - 1:
		return false
	else:
		points.remove(index)
		points.remove(index)
		points.remove(index)
		points.remove(index)
		
		curve_changed()
	return true

func get_point_count() -> int:
	return points.size() / 4

func set_point(i : int, v : Point) -> void:
	var indx : int = i * 4
	
	points[indx + 0] = v.p.x
	points[indx + 1] = v.p.y
	points[indx + 2] = v.ls
	points[indx + 3] = v.rs
	
	curve_changed()

func get_point(i : int) -> Point:
	var indx : int = i * 4
	
	return Point.new(points[indx + 0], points[indx + 1], points[indx + 2], points[indx + 3])
	
func get_points() -> Array:
	var arr : Array = Array()
	
	var c : int = get_point_count()
	
	for i in range(c):
		arr.append(get_point(i))
		
	return arr

func set_points(arr : Array, notify : bool = true) -> void:
	points.resize(0)
	
	for p in arr:
		points.append(p.p.x)
		points.append(p.p.y)
		points.append(p.ls)
		points.append(p.rs)
		
	if notify:
		curve_changed()

func curve_changed() -> void:
	_curve_changed()

func _curve_changed() -> void:
	emit_changed()
