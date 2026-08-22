extends RayCast3D

class_name Bullet

const GRAVITY: Vector3 = Vector3(0, -9.8, 0)
const DRAG_FACTOR: float = 0.00005
const LIFETIME: float = 5

@export var damage: float = 1.0

@export var particles: GPUParticles3D
@export var mesh: MeshInstance3D


var velocity: Vector3 = Vector3.ZERO

var alive_time: float = 0
var hit: bool = false

func _ready() -> void:
	global_basis = Basis.looking_at(velocity)
	

func _physics_process(delta: float) -> void:
	if not hit:
		alive_time += delta
		if alive_time > LIFETIME:
			queue_free()
		
		global_basis = Basis.looking_at(velocity)
		
		var movement: Vector3 = velocity * delta
		target_position = to_local(global_position + movement)
		force_raycast_update()
		if not is_colliding():
			global_position += movement
		else:
			hit = true
			global_position = get_collision_point()
			if particles:
				if mesh:
					mesh.hide()
				particles.emitting = true
				particles.finished.connect(queue_free)
			else:
				queue_free()
		
		velocity += GRAVITY * delta
		velocity -= velocity.normalized() * DRAG_FACTOR * velocity.length() ** 2.0
		
	
