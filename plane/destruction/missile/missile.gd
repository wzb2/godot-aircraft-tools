@tool
extends AeroBody3D

class_name Missile

@export var launch_on_ready: bool = true

@onready var control_component: AeroControlComponent = $AeroControlComponent
@onready var particles: GPUParticles3D = $GPUParticles3D


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
	
	particles.global_position = global_position


func explode() -> void:
	particles.emitting = false
	var tween: Tween = get_tree().create_tween()
	tween.tween_callback(particles.queue_free).set_delay(particles.lifetime)
	
	queue_free()
	
