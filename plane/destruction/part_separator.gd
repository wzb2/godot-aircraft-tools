extends Node

## Nested PartSeparators don't really work yet. 
class_name PartSeparator

signal sepreate

## Makes the part detach when you press space. 
@export var enable_debug_button: bool = false

## Makes the part seperate when the aero body experiences more than more accelleration than the impact_accleration_threshold. 
@export var seperate_on_impact: bool = true
## in m/s^2
@export var impact_accleration_threshold: float = 1000

@export var collision_shape: CollisionShape3D
## The AeroInfluencer to be separated. Is set to this node's parent if left empty. 
@export var part: AeroInfluencer3D
## Mass of the part when it falls off. 
@export var debris_mass: float = 40.0
## If true, subtracts debris_mass from the part's original aero body when it falls off, so no new mass is generated. 
@export var make_aero_body_lighter: bool = true

var aero_body: AeroBody3D:
	get():
		return part.aero_body

var separated: bool = false

func _ready() -> void:
	if not part:
		part = get_parent()

func _input(event: InputEvent) -> void:
	if enable_debug_button:
		if event is InputEventKey:
			if event.keycode == KEY_SPACE:
				separate()
			

func _physics_process(_delta: float) -> void:
	if seperate_on_impact:
		var accel: float = get_linear(aero_body.linear_acceleration, aero_body.angular_acceleration, aero_body.global_basis, aero_body.to_local(part.global_position)).length()
		if accel > impact_accleration_threshold:
			separate()

func separate() -> void:
	if not separated:
		separated = true
		sepreate.emit()
		
		if make_aero_body_lighter:
			aero_body.mass -= debris_mass
		
		var debris: AeroBody3D = AeroBody3D.new()
		#debris.show_debug = true
		debris.mass = debris_mass
		debris.global_transform = part.global_transform
		aero_body.add_sibling(debris)
		
		debris.linear_velocity = get_linear(aero_body.linear_velocity, aero_body.angular_velocity, aero_body.global_basis, aero_body.to_local(part.global_position))
		
		part.reparent(debris)
		collision_shape.reparent(debris)
		part.default_transform = Transform3D.IDENTITY
		
		queue_free()
		


func get_linear(linear: Vector3, angular: Vector3, body_global_basis: Basis, local_offset: Vector3) -> Vector3:
	return linear + angular.cross(body_global_basis * local_offset)
	
