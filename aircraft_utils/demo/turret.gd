extends Node3D

class_name Turret

@export var gun: MachineGun

@export var vehicle: RigidBody3D

@export var target: Node3D

@export var max_range: float = 600

## Gravity multiplier
@export var drop_fudge: float = 3
## Time of flight fidge for velocity offset calculation
@export var tof_fudge: float = 1


func _physics_process(_delta: float) -> void:
	var dist_to_target: float = global_position.distance_to(target.global_position)
	var tof: float = dist_to_target / gun.muzzle_speed
	var drop: Vector3 = Vector3.DOWN * 9.8 * tof**2.0 * 0.5 * drop_fudge
	var vel: Vector3 = vehicle.linear_velocity if vehicle else Vector3.ZERO
	if target is RigidBody3D:
		gun.look_at(target.global_position + (target.linear_velocity - vel) * tof * tof_fudge - drop)
	else:
		gun.look_at(target.global_position - vel * tof - drop)
	
	gun.firing = dist_to_target < max_range
	
