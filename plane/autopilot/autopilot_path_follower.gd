extends Node

class_name AutopilotPathFollower

@export var aerobody: AeroBody3D

@export var path: Path3D

@export var loop: bool = true
@export var enabled: bool = true

@export var look_ahead_time: float = 1.0
@export var at_point_distance: float = 300

@onready var control_component: AeroControlComponent = aerobody.find_children("*", "AeroControlComponent")[0]
@onready var flight_assist: FlightAssist = control_component.flight_assist

var target_point_index: int = 0


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	if enabled:
		flight_assist.enable_target_direction = true
		var points: PackedVector3Array = path.curve.get_baked_points()
		var target_point: Vector3 = path.global_transform * points[target_point_index]#path.curve.get_point_position(target_point_index)
		var next_point: Vector3 = path.global_transform * points[(target_point_index + 1) % points.size()]#path.curve.get_point_position((target_point_index + 1) % path.curve.point_count)
		var look_ahead_point: Vector3 = aerobody.global_position + aerobody.linear_velocity * look_ahead_time
		
		if (aerobody.global_position.distance_to(target_point) < at_point_distance
		or look_ahead_point.distance_to(target_point) < at_point_distance
		or aerobody.global_position.distance_to(target_point) > aerobody.global_position.distance_to(next_point)):
			print("Reached Point ", target_point_index, " at ", target_point)
			print("Y error: ", aerobody.global_position.y - target_point.y)
			target_point_index += 1
			#if target_point_index >= path.curve.point_count:
			if target_point_index >= points.size():
				target_point_index = 0
				if not loop:
					enabled = false
					flight_assist.enable_target_direction = false
					
		
		flight_assist.direction_target = aerobody.global_position.direction_to(target_point)
		
