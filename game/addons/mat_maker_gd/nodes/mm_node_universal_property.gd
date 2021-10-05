tool
class_name MMNodeUniversalProperty
extends Resource

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

export(Resource) var obj : Resource
export(String) var getter : String
export(Array) var params : Array

func get_value(uv : Vector2):
	if !obj:
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
	
	if params.size() == 0:
		return obj.call(getter, uv)
	else:
		return obj.call(getter, uv, params)

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
