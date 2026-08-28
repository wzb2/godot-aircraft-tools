extends StaticBody3D

@export var gun: MachineGun

@export var target: Node3D

@export var range: float = 600

func _physics_process(_delta: float) -> void:
	var dist_to_target: float = global_position.distance_to(target.global_position)
	var tof: float = dist_to_target / gun.muzzle_speed
	var drop: Vector3 = Vector3.DOWN * 9.8 * tof**2.0 * 0.5 * 3
	if target is RigidBody3D:
		gun.look_at(target.global_position + target.linear_velocity * tof * 1.25 - drop)
	else:
		gun.look_at(target.global_position - drop)
	
	gun.firing = dist_to_target < range
	
