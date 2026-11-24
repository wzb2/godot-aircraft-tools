extends Node2D

class_name Dial2D

## Node to get input value from. 
@export var target_node: Node

## Expression executed with target_node as the base instance to get the input value. [br]Ex: "airspeed", linear_velocity.length()", "altitude", "global_position.y"
@export var get_value_expression: String

## The unit conversion from the input value to one rotation of the dial. The input value is returned by the get value expression. 
@export var amount_per_turn: float = 1

var expression: Expression = Expression.new()

func _ready() -> void:
	var error: Error = expression.parse(get_value_expression)
	assert(error == OK, "Dial get value expression parse failed with error: " + error_string(error))

func _process(_delta: float) -> void:
	var value: float = float(expression.execute([], target_node))
	assert(not expression.has_execute_failed(), "Dial get value expression execute failed with error: " + expression.get_error_text())
	
	rotation = 2 * PI * value / amount_per_turn
	
