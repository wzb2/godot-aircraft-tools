@tool
extends Bomb

class_name Missile

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
	continuous_cd = true
	if not Engine.is_editor_hint():
		contact_monitor = true
		max_contacts_reported = 1
		
		if launch_on_ready:
			launch()


func launch() -> void:
	control_component.set_control_input("throttle", 1.0)
	particles.emitting = true


func _physics_process(delta : float) -> void:
	super._physics_process(delta)
	
	if not Engine.is_editor_hint():
		if hitbox:
			if hitbox.hp <= 0:
				explode()
	


func explode() -> void:
	particles.reparent(get_tree().current_scene, true)
	particles.emitting = false
	var tween: Tween = get_tree().create_tween()
	tween.tween_callback(particles.queue_free).set_delay(particles.lifetime)
	super.explode()
	
