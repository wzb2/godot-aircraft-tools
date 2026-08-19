extends Node

class_name PartSeparator

@export var collision_shape: CollisionShape3D
## Parent by default
@export var part: AeroInfluencer3D
@export var debris_mass: float = 40.0

var aero_body: AeroBody3D

var separated: bool = false

func _ready() -> void:
	if not part:
		part = get_parent()
	aero_body = part.get_parent()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			separate()
			

func separate() -> void:
	if not separated:
		separated = true
		var debris: AeroBody3D = AeroBody3D.new()
		#debris.show_debug = true
		debris.mass = debris_mass
		debris.global_transform = part.global_transform
		aero_body.add_sibling(debris)
		
		debris.linear_velocity = aero_body.linear_velocity + aero_body.angular_velocity.cross(part.position)
		
		part.reparent(debris)
		collision_shape.reparent(debris)
		part.default_transform = Transform3D.IDENTITY
		
		aero_body.mass -= debris_mass
		
		queue_free()
		
