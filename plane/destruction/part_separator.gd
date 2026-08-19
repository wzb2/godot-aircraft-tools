extends Node

class_name PartSeparator

@export var collision_shape: CollisionShape3D
## Parent by default
@export var part: AeroInfluencer3D
@export var debris_mass: float = 40.0

var aero_body: AeroBody3D

func _ready() -> void:
	if not part:
		part = get_parent()
	aero_body = part.get_parent()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			separate()

func separate() -> void:
	var debris: AeroBody3D = AeroBody3D.new()
	debris.mass = debris_mass
	aero_body.add_sibling(debris)
	debris.global_position = part.global_position
	debris.global_rotation = part.global_rotation
	debris.linear_velocity = aero_body.linear_velocity + aero_body.angular_velocity.cross(part.position)
	part.reparent(debris)
	part.aero_body = debris
	if aero_body.aero_influencers.has(part):
		aero_body.aero_influencers.erase(part)
		print("aaaaaaaaaaaaaaaaaa")
	if not debris.aero_influencers.has(part):
		debris.aero_influencers.append(part)
		print("AAAAAAAAAAAAAAAAAA")
	
	collision_shape.reparent(debris)
	
	aero_body.mass -= debris_mass
	
	if part is AeroPropeller3D:
		debris.angular_velocity = part.propeller_speed_control_config.current_value
	
	queue_free()
	
