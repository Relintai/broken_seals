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
	SLOT_TYPE_COLOR = 5,
	SLOT_TYPE_UNIVERSAL = 6,
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

var get_value_from_owner : bool = false
var force_override : bool = false
#This is not exported on purpose!
var override_image : Image

#Should be a MMNodeUniversalProperty, but can't set it up like that
export(Resource) var input_property : Resource

var input_slot_type : int = SlotTypes.SLOT_TYPE_NONE
var output_slot_type : int = SlotTypes.SLOT_TYPE_NONE
var slot_name : String
var value_step : float = 0.1
var value_range : Vector2 = Vector2(-1000, 1000)

#MMNode
var owner

func _init():
	if input_property:
		input_property.connect("changed", self, "on_input_property_changed")

func get_value(uv : Vector2, skip_owner_val : bool = false):
	if get_value_from_owner && !skip_owner_val:
		return get_owner_value(uv)
	
	if !input_property:
		return get_default_value(uv)
	
	if default_type == input_property.default_type:
		return input_property.get_value(uv)
	
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		return to_int(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		return to_float(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		return to_vector2(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		return to_vector3(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		return to_color(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		return to_color(input_property.get_value(uv))
		
	return input_property.get_value(uv)

func get_owner_value(uv : Vector2):
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		return to_int(owner.get_property_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		return to_float(owner.get_property_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		return to_vector2(owner.get_property_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		return to_vector3(owner.get_property_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		return to_color(owner.get_property_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		return to_color(owner.get_property_value(uv))

func get_value_or_zero(uv : Vector2, skip_owner_val : bool = false):
	if get_value_from_owner && !skip_owner_val:
		return get_owner_value(uv)
	
	if !input_property:
		return get_zero_value()
	
	if default_type == input_property.default_type:
		return input_property.get_value(uv)
	
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		return to_int(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		return to_float(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		return to_vector2(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		return to_vector3(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		return to_color(input_property.get_value(uv))
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		return to_color(input_property.get_value(uv))
		
	return input_property.get_value(uv)

func get_value_sdf3d(uv3 : Vector3, skip_owner_val : bool = false) -> Vector2:
	if get_value_from_owner && !skip_owner_val:
		return owner.get_property_value_sdf3d(uv3)
	
	if !input_property:
		return default_vector2
	
	return input_property.get_value_sdf3d(uv3)

func to_int(val) -> int:
	if val is int:
		return val
	
	if val is float:
		return int(val)
	
	if val is Vector2:
		return int(val.x)
		
	if val is Vector3:
		return int(val.x)
	
	if val is Color:
		return int(val.r)
	
	return 0

func to_float(val) -> float:
	if val is float:
		return val
		
	if val is int:
		return float(val)
	
	if val is Vector2:
		return float(val.x)
		
	if val is Vector3:
		return float(val.x)
	
	if val is Color:
		return float(val.r)
	
	return 0.0
	
func to_vector2(val) -> Vector2:
	if val is Vector2:
		return val
		
	if val is int:
		return Vector2(val, val)
		
	if val is float:
		return Vector2(val, val)
		
	if val is Vector3:
		return Vector2(val.x, val.y)
	
	if val is Color:
		return Vector2(val.r, val.g)
	
	return Vector2()
	
func to_vector3(val) -> Vector3:
	if val is Vector3:
		return val
		
	if val is int:
		return Vector3(val, val, val)
		
	if val is float:
		return Vector3(val, val, val)
		
	if val is Vector2:
		return Vector3(val.x, val.y, 0)
	
	if val is Color:
		return Vector3(val.r, val.g, val.b)
	
	return Vector3()
	
func to_color(val) -> Color:
	if val is Color:
		return val
		
	if val is int:
		return Color(val, val, val, 1)
		
	if val is float:
		return Color(val, val, val, 1)
		
	if val is Vector2:
		return Color(val.x, val.y, 0, 1)
	
	if val is Vector3:
		return Color(val.x, val.y, val.z, 1)
	
	return Color()

func set_value(val):
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		override_image = val
		emit_changed()
		return
		
	set_default_value(val)

func get_zero_value():
	if default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_INT:
		return 0
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT:
		return 0.0
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2:
		return Vector2()
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR3:
		return Vector3()
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR:
		return Color()
	elif default_type == MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE:
		return Color()
		
	return null

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
			return default_color

		image.lock()
		var x : int = uv.x * image.get_width()
		var y : int = uv.y * image.get_height()
		
		x = clamp(x, 0, image.get_width() - 1)
		y = clamp(y, 0, image.get_width() - 1)
		
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

func get_active_image() -> Image:
	if !force_override && input_property:
		return input_property.get_active_image()
		
	if override_image:
		return override_image
		
	return default_image

func set_input_property(val : MMNodeUniversalProperty) -> void:
	if input_property == val:
		return
		
	if input_property:
		input_property.disconnect("changed", self, "on_input_property_changed")
	
	input_property = val
	
	if input_property:
		input_property.connect("changed", self, "on_input_property_changed")
		
	emit_changed()

# Because in UndiRedo if you pass null as the only argument it will look
# for a method with no arguments
func unset_input_property() -> void:
	set_input_property(null)

func on_input_property_changed() -> void:
	emit_changed()
