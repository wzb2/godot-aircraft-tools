extends Camera3D

const MOUSE_SENSITIVITY: float = 0.2

var mouse_eaten: bool:
	get():
		return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _input(event: InputEvent) -> void:
	if get_tree().current_scene:
		if not get_tree().current_scene.name == "MainMenu":
			if event is InputEventMouseButton:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
		if event is InputEventKey:
			if event.keycode == KEY_ESCAPE and event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	

func _unhandled_input(event):
	if event is InputEventMouseMotion and mouse_eaten:
		rotation.y += (deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		rotation.x += (deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		rotation.x = clamp(rotation.x, -PI * 0.5, PI * 0.5)
