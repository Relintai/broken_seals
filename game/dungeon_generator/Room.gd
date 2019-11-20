extends RigidBody2D

var size : Vector2

func make_room(_pos : Vector2, _size : Vector2):
	position = _pos
	size = _size
	
	var s : RectangleShape2D = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	
	$CollisionShape2D.shape = s
