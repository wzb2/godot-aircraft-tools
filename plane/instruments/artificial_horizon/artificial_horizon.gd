@tool
extends Node3D

@export var ball: Node3D
@export var bank_scale: Node3D

func _physics_process(_delta: float) -> void:
	if ball:
		ball.global_basis = Basis.looking_at(Vector3.FORWARD)
		ball.rotate_z(PI)
		
	if bank_scale:
		bank_scale.global_rotation.x = global_rotation.x
		bank_scale.global_rotation.z = 0
		bank_scale.global_rotation.y = global_rotation.y
	
