extends Area3D

class_name AircraftPartHitbox

@export var hp: float = 200

@export var aero_influencer: AeroInfluencer3D

@export var can_disable_control: bool = true
@export var disable_control_threshold: float = 80

@export var part_spearator: PartSeparator
@export var separate_threshold: float = 0


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
	if part_spearator:
		if hp <= separate_threshold:
			part_spearator.separate()


func _physics_process(_delta: float) -> void:
	update()
