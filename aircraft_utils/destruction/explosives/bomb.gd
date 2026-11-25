@tool
extends AeroBody3D

class_name Bomb

## Impact force to trigger an explosion. 
@export var explode_force_threshold: float = 100
## Explosion when explosive hits something. 
@export var explosion_scene: PackedScene

func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		contact_monitor = true
		max_contacts_reported = 1

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	super._integrate_forces(state)
	if state.get_contact_count() > 0:
		#var collider: Object = state.get_contact_collider_object(0)
		if state.get_contact_impulse(0).length() > explode_force_threshold:
			explode()
			


func explode() -> void:
	var explosion: Explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	queue_free()
