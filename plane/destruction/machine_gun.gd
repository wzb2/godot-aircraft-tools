extends Node3D

class_name MachineGun

const BULLET: PackedScene = preload("uid://2fvdaoir5c8y")

## To calculate initial velocity
@export var vehicle: RigidBody3D
## m/s
@export var muzzle_speed: float = 870
@export var continuous_recoil_force: float = 750
@export var rpm: float = 800
@onready var firing_cooldown: float = 60.0 / rpm

@export var firing: bool = false

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = firing_cooldown
	timer.timeout.connect(shoot)

func _physics_process(_delta: float) -> void:
	if firing and timer.is_stopped():
		timer.start()
	elif not firing and not timer.is_stopped():
		timer.stop()
	elif firing:
		vehicle.apply_force(global_transform.basis.z * continuous_recoil_force, position)
	

func shoot() -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.velocity = -global_transform.basis.z * muzzle_speed + vehicle.linear_velocity #TODO: factor in angular velocity, move get_linear function from part seperator to utils class? 
	vehicle.add_sibling(bullet)
	bullet.global_position = global_position
	bullet.add_exception(vehicle)
	
