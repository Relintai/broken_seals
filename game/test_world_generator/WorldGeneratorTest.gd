tool
extends Sprite

var brenzenham_script = preload("res://test_world_generator/brenzenham.gd")
var brenzenham

export(int) var continent_width : int = 1024
export(int) var continent_height : int = 1024

export(int) var biome_vertex_count : int = 20
export(int) var biome_count : int = 7

export(Color) var biome_vertex_color : Color = Color(1, 1, 1, 1)

var tex : ImageTexture
var img : Image 

export(bool) var do_clear_image setget do_clear_image
export(bool) var do_generate_biome_mesh setget do_generate_biome_mesh
export(bool) var do_draw_biome_mesh setget do_draw_biome_mesh
export(bool) var do_draw_biome_vertices setget do_draw_biome_vertices

var biome_vertices : PoolVector2Array 
var biome_indices : PoolIntArray 

# Called when the node enters the scene tree for the first time.
func _ready():
	brenzenham = brenzenham_script.new()
	
	img = Image.new()
	img.create(continent_width, continent_height, false, Image.FORMAT_RGBA8)
	tex = ImageTexture.new()

	texture = tex

func clear_image():
	fill_image(Color(0, 0, 0, 1))

func generate_biome_mesh():
	biome_vertices.resize(biome_vertex_count)
	
	for i in range(biome_vertex_count):
		biome_vertices[i] = Vector2(randf() * continent_width, randf() * continent_height)
		
	biome_indices = Geometry.triangulate_delaunay_2d(biome_vertices)
	
func draw_biome_mesh():
	for i in range(0, biome_indices.size(), 3):
		draw_image_line(biome_vertices[biome_indices[i]], biome_vertices[biome_indices[i + 1]], biome_vertex_color)
		draw_image_line(biome_vertices[biome_indices[i + 1]], biome_vertices[biome_indices[i + 2]], biome_vertex_color)
		draw_image_line(biome_vertices[biome_indices[i + 2]], biome_vertices[biome_indices[i]], biome_vertex_color)
		
	tex.create_from_image(img, 0)
		
func draw_image_line(p1 : Vector2, p2 : Vector2, color : Color):
	brenzenham.draw_line(int(p1.x), int(p1.y), int(p2.x), int (p2.y), img, color)

func draw_biome_vertices():
	var size : int = 4
	var vc : Color = Color(1, 1, 0, 1)
	
	img.lock()
	
	for i in range(biome_vertices.size()):
		var pv : Vector2 = biome_vertices[i]
		
		var sx : int = int(pv.x) - size / 2 
		var sy : int = int(pv.y) - size / 2 
		var ex : int = sx + size
		var ey : int = sy + size
		
		for x in range(sx, ex):
			for y in range(sy, ey):
				img.set_pixel(x, y, vc)
	
	img.unlock()
	
	tex.create_from_image(img, 0)
	

func fill_image(color: Color):
	img.lock()
	
	for x in img.get_width():
		for y in img.get_height():
			img.set_pixel(x, y, color)
	
	img.unlock()
	
	tex.create_from_image(img, 0)

# ----- setters -----

func do_clear_image(v):
	if v:
		clear_image()

func do_generate_biome_mesh(v):
	if v:
		generate_biome_mesh()

func do_draw_biome_vertices(v):
	if v:
		draw_biome_vertices()
	
func do_draw_biome_mesh(v):
	if v:
		draw_biome_mesh()
