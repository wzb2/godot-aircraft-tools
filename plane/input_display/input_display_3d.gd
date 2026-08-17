extends Node3D

class_name InputDisplay3D

@export var control_component: Node

@export var axis_configs: Array[InputDisplayConfig] = []

@onready var rest_transform: Transform3D = transform

func _physics_process(_delta: float) -> void:
	transform = rest_transform
	for c: InputDisplayConfig in axis_configs:
		var input: float = 0
		if InputMap.has_action(c.positive_event):
			input += Input.get_action_strength(c.positive_event)
		if InputMap.has_action(c.negative_event):
			input -= Input.get_action_strength(c.negative_event)
		
		if c.control_config_axis:
			if control_component.has_method("get_control_command"):
				input = control_component.get_control_command(c.control_config_axis)
		
		var translation_offset: Vector3 = c.linear_range_of_motion * input
		var rotation_offset: Vector3 = c.angular_range_of_motion * input
		rotation_degrees += rotation_offset
		position += translation_offset
		
