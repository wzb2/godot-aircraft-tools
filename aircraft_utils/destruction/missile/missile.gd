@tool
extends AeroBody3D

class_name Missile

const PARTICLE_Z_OFFSET: float = 0.5

## If true, automatically launches when _ready is called, starting thrusters, particles, and guidance if it is a guided missile. 
@export var launch_on_ready: bool = true

## The AeroControlComponent for throttle and guidance if it is a guided missile. 
@export var control_component: AeroControlComponent
## Particles to emit when the missile is flying. 
@export var particles: GPUParticles3D
## Hitbox for getting shot down. 
@export var hitbox: AircraftPartHitbox


func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		contact_monitor = true
		max_contacts_reported = 1
		
		if launch_on_ready:
			launch()


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	super._integrate_forces(state)
	if state.get_contact_count() > 0:
		#var collider: Object = state.get_contact_collider_object(0)
		if state.get_contact_impulse(0).length() > 100:
			explode()
			

func launch() -> void:
	control_component.set_control_input("throttle", 1.0)
	particles.reparent(get_tree().current_scene, true)
	particles.emitting = true


func _physics_process(delta : float) -> void:
	super._physics_process(delta)
	
	if not Engine.is_editor_hint():
		particles.global_position = global_position + global_basis.z * PARTICLE_Z_OFFSET
		
		if hitbox:
			if hitbox.hp <= 0:
				explode()
	


func explode() -> void:
	particles.emitting = false
	var tween: Tween = get_tree().create_tween()
	tween.tween_callback(particles.queue_free).set_delay(particles.lifetime)
	
	queue_free()
	
