tool
extends TextureRect

func set_texture(tex: Texture)-> void:
	texture = tex
	
	if tex is PackerImageResource:
		var t : ImageTexture = ImageTexture.new()
		
		t.create_from_image(tex.data, 0)
		
		texture = t
