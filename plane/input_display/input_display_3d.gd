extends Node3D

class_name InputDisplay3D

const RAD_TO_DEG: float = 360.0 / TAU

@export var control_component: AeroControlComponent

@export var axis_configs: Array[InputDisplayConfig] = []

@export var move_speed: float = 1000

@onready var rest_transform: Transform3D = transform

func _physics_process(_delta: float) -> void:
	transform = rest_transform
	#var total_pos_offset: Vector3 = Vector3.ZERO
	#var total_rot_offset: Vector3 = Vector3.ZERO
	for c: InputDisplayConfig in axis_configs:
		var input: float = 0
		if InputMap.has_action(c.positive_event):
			input += Input.get_action_strength(c.positive_event)
		if InputMap.has_action(c.negative_event):
			input -= Input.get_action_strength(c.negative_event)
		
		if c.control_config_axis:
			#if control_component.has_method("get_control_command"):
			input = control_component.get_control_command(c.control_config_axis)
		
		var position_offset: Vector3 = c.linear_range_of_motion * input
		var rotation_offset: Vector3 = c.angular_range_of_motion * input
		position += position_offset
		rotation_degrees += rotation_offset
		#total_pos_offset += position_offset
		#total_rot_offset += rotation_offset
		#
	#rotation_degrees = rotation_degrees.move_toward(rest_transform.basis.get_euler() * RAD_TO_DEG + total_rot_offset, move_speed * delta)
	#position = position.move_toward(rest_transform.origin + total_pos_offset, move_speed * delta)
	
