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
}

export(int, "Int,Float,Vector2,Vector3,Color") var default_type : int

export(int) var default_int : int
export(float) var default_float : float
export(Vector2) var default_vector2 : Vector2
export(Vector3) var default_vector3 : Vector3
export(Color) var default_color : Color

#Should be a MMNodeUniversalProperty, but can't set it up like that
export(Resource) var input_property : Resource

func get_value(uv : Vector2):
	if !input_property:
		return get_default_value()
	
	return input_property.get_value(uv)

func get_default_value():
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
		
	emit_changed()
