extends StaticBody

export(Color) var default_albedo : Color = Color(0.494118, 0.494118, 0.494118)
export(Color) var hover_albedo : Color = Color(0.65098, 0.65098, 0.65098)
export(float) var use_range : float = 5

export(PackedScene) var dungeon : PackedScene
export(PackedScene) var dungeon_back_teleporter : PackedScene

var min_level : int = 1
var max_level : int = 2

var owner_chunk : TerraChunk = null
var _dungeon : Spatial = null
var _dungeon_back_teleporter : Spatial = null

var teleport_to : Vector3 = Vector3()

var _world : TerraWorld = null

func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = default_albedo
	
func on_mouse_entered():
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = hover_albedo
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func on_mouse_exited():
	var mat = $MeshInstance.get_surface_material(0)
	mat.albedo_color = default_albedo
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _enter_tree():
	_world = get_node("..")
	
	if _world:
		_world.connect("chunk_removed", self, "on_chunk_removed")

func _exit_tree():
	if _world:
		_world.disconnect("chunk_removed", self, "on_chunk_removed")
	
	if _dungeon:
		_dungeon.queue_free()
		
	if _dungeon_back_teleporter:
		_dungeon_back_teleporter.queue_free()

func _input_event(camera: Object, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton && !event.pressed:
		teleport()
	
	if event is InputEventScreenTouch && !event.pressed:
		teleport()

func teleport():
	if _world && _world._player:
		var p : Entity = _world._player

		if (p.get_body().transform.origin - transform.origin).length() > use_range:
			return

		if !_dungeon:
			_dungeon = dungeon.instance() as Spatial
			var t : Transform = global_transform
			t = t.translated(Vector3(0, -500, 0))
			_dungeon.transform = t 
			_dungeon.min_level = min_level
			_dungeon.max_level = max_level
			get_parent().add_child(_dungeon)
			
			teleport_to = t.xform(Vector3())
			#todo add this into the dungeon and just query
			teleport_to -= Vector3(-5, -1, 5)
			
			_dungeon_back_teleporter = dungeon_back_teleporter.instance() as Spatial
			var tdb : Transform = global_transform
			tdb = tdb.translated(Vector3(0, -500, 0))
			tdb = tdb.translated(Vector3(1, 0.5, -1))
			_dungeon_back_teleporter.transform = tdb
			_dungeon_back_teleporter.teleport_to = global_transform.xform(Vector3())
			get_parent().add_child(_dungeon_back_teleporter)
			
		#turn off world
		_world.active = false
		#turn on dungeon
		_dungeon.show()
		
		p.get_body().teleport(teleport_to)
#		p.get_body().transform.origin = teleport_to


func on_chunk_removed(chunk : TerraChunk) -> void:
	if chunk == owner_chunk:
		queue_free()

