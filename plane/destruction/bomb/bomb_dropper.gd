extends Node3D

class_name BombDropper

@export var vehicle: RigidBody3D
@export var bomb_scene: PackedScene
@export var amount: int = 1
@export var drop_speed: float = 0.0
@export var input_event: StringName = "bomb"

func _ready() -> void:
	var bomb: RigidBody3D = bomb_scene.instantiate()
	vehicle.mass += amount * bomb.mass
	bomb.free()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(input_event):
		drop()


func drop() -> void:
	if amount > 0:
		amount -= 1
		var bomb: RigidBody3D = bomb_scene.instantiate()
		get_parent().add_sibling(bomb)
		bomb.global_transform = global_transform
		bomb.linear_velocity = vehicle.linear_velocity
		bomb.angular_velocity = vehicle.angular_velocity
		
		bomb.linear_velocity += bomb.global_basis.y * -drop_speed
		
		vehicle.mass -= bomb.mass
		
	
