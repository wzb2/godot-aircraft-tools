extends Resource

## Used to configure movement along an axis for an InputDisplay3D. 
class_name InputDisplayAxisConfig

## Positive input event. Use control_config_axis if taking input from Aerodynamic Physics control config (useful for colective input like throttle). 
@export var positive_event: StringName
## Negative input event. Use control_config_axis if taking input from Aerodynamic Physics control config (useful for colective input like throttle). 
@export var negative_event: StringName
## Name of the Aerodynamic Physics control config axis to take input from. Use if taking input from Aerodynamic Physics control config instead of positive_event and negative_event, otherwise leave blank. 
@export var control_config_axis: StringName
## Translation offset when the input totals 1. If input is negative, it will go the other way. 
@export var linear_range_of_motion: Vector3
## Rotation offset as an euler angle in degrees when the input totals 1. If input is negative, it will go the other way. 
@export var angular_range_of_motion: Vector3
