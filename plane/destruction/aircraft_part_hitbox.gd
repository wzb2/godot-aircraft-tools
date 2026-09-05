extends Area3D

## Hitbox for aircraft parts. Makes parts fall off or be disabled when damaged a certain amount. Used to make bullets affect aircraft. 
class_name AircraftPartHitbox

## Amount of damage this part can sustain. 
@export var hp: float = 200

## AeroInfluencer to affect. 
@export var aero_influencer: AeroInfluencer3D

## If true, control of aero_influencer will be disabled when hp <= disable_control_threshold. 
@export var can_disable_control: bool = true
@export var disable_control_threshold: float = 80

## Part separator to use to make part fall off when hp <= separate_threshold. Leave null if uneeded. 
@export var part_spearator: PartSeparator
@export var separate_threshold: float = 0


func _ready() -> void:
	if not aero_influencer:
		if get_parent() is AeroInfluencer3D:
			aero_influencer = get_parent()


func hit(damage: float) -> void:
	hp -= damage
	#update()

func update() -> void:
	if can_disable_control:
		if hp <= disable_control_threshold:
			if aero_influencer:
				var control_config: AeroInfluencerControlConfig = aero_influencer.actuation_config
				if control_config:
					control_config.enable_control = false
				if aero_influencer is AeroPropeller3D:
					var speed_config: AeroInfluencerControlConfig = aero_influencer.propeller_speed_control_config
					speed_config.enable_control = false
					speed_config.current_value = Vector3.ZERO
				elif aero_influencer is AeroThruster3D:
					var throttle_config: AeroInfluencerControlConfig = aero_influencer.throttle_control_config
					throttle_config.enable_control = false
					throttle_config.current_value = Vector3.ZERO
	if part_spearator:
		if hp <= separate_threshold:
			part_spearator.separate()


func _physics_process(_delta: float) -> void:
	update()
