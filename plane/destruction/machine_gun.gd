extends Node3D

class_name MachineGun

const BULLET: PackedScene = preload("uid://2fvdaoir5c8y")

## To calculate initial velocity
@export var vehicle: RigidBody3D
## To disable when seperated
@export var separator: PartSeparator
@export var objects_to_ignore: Array[CollisionObject3D] = []
@export var recursive_ignore: bool = true
@export var muzzle_particles: GPUParticles3D
## m/s
@export var muzzle_speed: float = 870
@export var continuous_recoil_force: float = 750
@export var rpm: float = 800
@onready var firing_cooldown: float = 60.0 / rpm

@export var shoot_input_event: StringName

@export var attached = true

var firing: bool = false

@onready var timer: Timer = Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.wait_time = firing_cooldown
	timer.timeout.connect(shoot)
	if separator:
		separator.sepreate.connect(func() -> void: attached = false)
	
	if recursive_ignore:
		var children_to_ignore: Array
		for i: CollisionObject3D in objects_to_ignore:
			children_to_ignore.append_array(i.find_children("*", "AircraftPartHitbox"))
		objects_to_ignore.append_array(children_to_ignore)

func _physics_process(_delta: float) -> void:
	if InputMap.has_action(shoot_input_event):
		firing = Input.is_action_pressed(shoot_input_event)
	firing = firing && attached
	
	if muzzle_particles:
		muzzle_particles.emitting = firing
	
	if firing and timer.is_stopped():
		timer.start()
		shoot()
	elif not firing and not timer.is_stopped():
		timer.stop()
	elif firing and vehicle:
		vehicle.apply_force(global_transform.basis.z * continuous_recoil_force, global_position - vehicle.global_position)
	


func shoot() -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.velocity = -global_transform.basis.z * muzzle_speed
	if vehicle:
		bullet.velocity += vehicle.linear_velocity #TODO: factor in angular velocity, move get_linear function from part seperator to utils class? 
		vehicle.add_sibling(bullet)
	else:
		get_parent_node_3d().add_sibling(bullet)
	
	for i: CollisionObject3D in objects_to_ignore:
		bullet.add_exception(i)
		
	bullet.global_position = global_position
	
