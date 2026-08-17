extends Node2D

class_name Dial2D

@export var target_node: Node
@export var get_value_expression: String

@export var amount_per_turn: float = 1

var expression: Expression = Expression.new()

func _ready() -> void:
	var error: Error = expression.parse(get_value_expression)
	assert(error == OK, "Dial get value expression parse failed with error: " + error_string(error))

func _process(_delta: float) -> void:
	var value: float = float(expression.execute([], target_node))
	assert(not expression.has_execute_failed(), "Dial get value expression execute failed with error: " + expression.get_error_text())
	
	rotation = 2 * PI * value / amount_per_turn
	
