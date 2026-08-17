extends Resource

class_name InputDisplayConfig

@export var positive_event: StringName
@export var negative_event: StringName
## If using Aerodynamic Physics control config instead of positive_event and negative_event
@export var control_config_axis: StringName
## Translation
@export var linear_range_of_motion: Vector3
## Euler angle in degrees
@export var angular_range_of_motion: Vector3
