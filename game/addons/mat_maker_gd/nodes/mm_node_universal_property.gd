tool
class_name MMNodeUniversalProperty
extends Resource

enum SlotTypes {
	SLOT_TYPE_NONE = -1,
	SLOT_TYPE_IMAGE = 0,
	SLOT_TYPE_INT = 1,
	SLOT_TYPE_FLOAT = 2,
	SLOT_TYPE_VECTOR2 = 3,
	SLOT_TYPE_VECTOR3 = 4,
	SLOT_TYPE_UNIVERSAL = 5,
}

enum MMNodeUniversalPropertyDefaultType {
	DEFAULT_TYPE_INT = 0,
	DEFAULT_TYPE_FLOAT = 1,
	DEFAULT_TYPE_VECTOR2 = 2,
	DEFAULT_TYPE_VECTOR3 = 3,
	DEFAULT_TYPE_COLOR = 4,
	DEFAULT_TYPE_IMAGE = 5,
}

export(int, "Int,Float,Vector2,Vector3,Color,Image") var default_type : int

export(int) var default_int : int
export(float) var default_float : float
export(Vector2) var default_vector2 : Vector2
export(Vector3) var default_vector3 : Vector3
export(Color) var default_color : Color
export(Image) var default_image : Image

#This is not exported on purpose!
var override_image : Image

#Should be a MMNodeUniversalProperty, but can't set it up like that
export(Resource) var input_property : Resource

var input_slot_type : int = SlotTypes.SLOT_TYPE_NONE
var output_slot_type : int = SlotTypes.SLOT_TYPE_NONE
var slot_name : String = ""
var value_step : float = 0.1
var value_range : Vector2 = Vector2(-1000, 1000)

func get_value(uv : Vector2):
	if !input_property:
		return get_default_value(uv)
	
	return input_property.get_value(uv)
	
func set_value(val):
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		override_image = val
		emit_changed()
		return
		
	set_default_value(val)

func get_default_value(uv : Vector2 = Vector2()):
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		return default_int
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		return default_float
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		return default_vector2
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		return default_vector3
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		return default_color
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		var image : Image = default_image
		
		if override_image:
			image = override_image
			
		if !image:
			return Color()

		image.lock()
		var x : int = uv.x * image.get_width()
		var y : int = uv.y * image.get_height()
		var c : Color = image.get_pixel(x, y)
		image.unlock()

		return c
		
	return null

func set_default_value(val):
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		default_int = val
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		default_float = val
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		default_vector2 = val
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		default_vector3 = val
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		default_color = val
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		default_image = val
		
	emit_changed()
