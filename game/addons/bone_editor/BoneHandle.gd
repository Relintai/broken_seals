tool
extends Spatial

class_name BoneHandle

var bone_editor
var skeleton:Skeleton = null
var bone_id:int = -1
var bone_name:String = ""
var original_rest:Transform
var original_parent_rest:Transform
var original_global_rest_origin:Vector3
var enabled:bool = true

var pose:Transform

func _ready( ):
	if self.skeleton == null or self.bone_id == -1:
		return

	self.original_rest = self.skeleton.get_bone_rest( self.bone_id )
	var parent_bone_id:int = self.skeleton.get_bone_parent( self.bone_id )
	if parent_bone_id != -1:
		self.original_parent_rest = self.skeleton.get_bone_global_pose( parent_bone_id )

	self.transform.basis = Basis( )
	self.transform.origin = self.original_parent_rest.basis.xform( self.original_rest.origin )
	self.original_global_rest_origin = self.transform.origin

func init_pose( ):
	self.transform.basis = Basis( )
	self.transform.origin = self.original_parent_rest.basis.xform( self.original_rest.origin )

func set_pose( basis:Basis, origin:Vector3 ):
	self.transform.basis = basis
	self.transform.origin = self.original_global_rest_origin + self.original_parent_rest.basis.xform( origin )
	# printt( self.bone_name, basis, origin )

func _process( delta:float ):
	if self.skeleton == null or self.bone_id == -1:
		return

	if self.enabled:
		var t:Transform = Transform( )
		t.basis = self.transform.basis
		t.origin = self.original_parent_rest.basis.xform_inv( self.transform.origin - self.original_global_rest_origin )
		self.skeleton.set_bone_pose( self.bone_id, t )
		self.pose = t
