extends RigidBody3D

class_name Bomb

@export var explode_force_threshold: float = 100
@export var fx_scene: PackedScene

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.get_contact_count() > 0:
		#var collider: Object = state.get_contact_collider_object(0)
		if state.get_contact_impulse(0).length() > explode_force_threshold:
			explode()
			


func explode() -> void:
	var fx: BombFX = fx_scene.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
	queue_free()
