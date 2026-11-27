extends Area3D

class_name Explosion

const RAY_MULTIPLIER: float = 1.1

const BASE_DAMAGE_MULTIPLIER: float = 0.1

@export var one_shot: bool = true
@export var explode_immidiately: bool = true

## Explosion force. 
@export var force: float = 500
## Override blast radius. Set to a positive number to use it instead of automatically trying to find the radius of the collision shape. 
@export var override_radius: float = -1
## Scale factor from force to damage, on top of base 0.1 multiplier. 
@export var damage_multiplier: float = 0.005

## How many random rays to cast to check if n object in the blast is behind cover or partial cover. 
@export var ray_count: int = 8
## Maximum random ray angle spread away from the ray directly to the body. 
@export var ray_spread_degrees: float = 15

## Objects to ignore
@export var ignore: Array[CollisionObject3D]

## ExplosionFX for the explosion. 
@export var fx_scene: PackedScene

var radius: float = override_radius

func _ready() -> void:
	if override_radius <= 0:
		var collsion_shapes: Array[Node] = find_children("*", "CollisionShape3D")
		assert(collsion_shapes.size() > 0, "No collision shapes and override_radius is <= 0")
		assert(collsion_shapes.size() <= 1, "More than one explosion collision shape. ")
		var collision_shape: CollisionShape3D = collsion_shapes.get(0)
		var shape: Shape3D = collision_shape.shape
		assert(shape is SphereShape3D, "Explosion collision shape is not sphere. ")
		if shape is SphereShape3D:
			radius = shape.radius

func _physics_process(_delta: float) -> void:
	if explode_immidiately:
		await get_tree().physics_frame
		explode()
		explode_immidiately = false


## must be called in physics process
func explode() -> void:
	var fx: ExplosionFX = fx_scene.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	params.from = global_position
	params.collision_mask = collision_mask
	
	for i: CollisionObject3D in ignore:
		params.exclude.append(i.get_rid())
	
	for a: Node3D in get_overlapping_areas():
		if a is AircraftPartHitbox:
			if a.aero_influencer:
				params.collide_with_areas = true
				params.collide_with_bodies = false
				blast_obj(a, params, space_state)
	for a: Node3D in get_overlapping_bodies():
		params.collide_with_areas = false
		params.collide_with_bodies = true
		blast_obj(a, params, space_state)
		
	if one_shot:
		queue_free()
	

func blast_obj(a: Node3D, params: PhysicsRayQueryParameters3D, space_state: PhysicsDirectSpaceState3D) -> void:
	for i: int in ray_count:
		var vector_to_body: Vector3 = (a.global_position - global_position) * RAY_MULTIPLIER
		var orthagonal_vector: Vector3 = vector_to_body.cross(Vector3.UP).normalized()
		if orthagonal_vector and vector_to_body != Vector3.ZERO:
			var ray_vector: Vector3 = vector_to_body.rotated(orthagonal_vector.rotated(vector_to_body.normalized(), TAU * randf()), deg_to_rad(ray_spread_degrees) * randf())
			params.to = global_position + ray_vector
			
			var hit_dictionary: Dictionary = space_state.intersect_ray(params)
			if hit_dictionary.get("collider") == a:
				if a is AircraftPartHitbox:
					var hit_point: Vector3 = params.to - a.aero_influencer.aero_body.global_position
					var force_scale_factor: float = 1 - (radius - hit_point.distance_to(global_position))
					var hit_force: Vector3 = (ray_vector.normalized() * force / ray_count) * force_scale_factor
					a.inflict_hit(hit_force.length() * damage_multiplier * BASE_DAMAGE_MULTIPLIER)
				elif a is RigidBody3D:
					var hit_point: Vector3 = params.to - a.global_position
					var force_scale_factor: float = 1 - (radius - hit_point.distance_to(global_position))
					var hit_force: Vector3 = (ray_vector.normalized() * force / ray_count) * force_scale_factor
					a.apply_impulse(hit_force, hit_point)
