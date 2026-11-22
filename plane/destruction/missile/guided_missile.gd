@tool

extends Missile

class_name GuidedMissile

const COMMIT_DIST: float = 50
const EXPLODE_DIST: float = 5
const GIVE_UP_DIST: float = 300

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
		
		if distance_to_target < COMMIT_DIST:
			if distance_to_target > min_dist or distance_to_target < EXPLODE_DIST:
				explode()
		elif prev_dist < distance_to_target and distance_to_target - min_dist > GIVE_UP_DIST:
			explode()
		
		prev_dist = distance_to_target
	
