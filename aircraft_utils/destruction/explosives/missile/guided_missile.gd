@tool

extends Missile

class_name GuidedMissile

## If the missile gets this close to the target, if it starts getting further away, it will immidiately explode. 
@export var commit_dist: float = 30
## If the missile gets this close to the target, it will immidiately explode. 
@export var explode_dist: float = 3
## If the missile is this much farther from the target than the closest it's been and it's getting farther away, it will explode. 
@export var give_up_dist: float = 300

var min_dist: float = INF
var prev_dist: float = INF

func launch() -> void:
	control_component.flight_assist.enable_target_direction = true
	super.launch()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if not Engine.is_editor_hint():
		var target: RigidBody3D = get_tree().current_scene.get_node("BigPlane")
		var distance_to_target: float = global_position.distance_to(target.global_position)
		var time_to_target: float = distance_to_target / linear_velocity.length()
		var target_pos_at_arrival: Vector3 = target.global_position + target.linear_velocity * time_to_target
		control_component.flight_assist.direction_target = global_position.direction_to(target_pos_at_arrival)
		
		if distance_to_target < min_dist:
			min_dist = distance_to_target
		
		if distance_to_target < commit_dist:
			if distance_to_target > prev_dist or distance_to_target < explode_dist:
				explode()
		elif prev_dist < distance_to_target and distance_to_target - min_dist > give_up_dist:
			explode()
		
		prev_dist = distance_to_target
	
