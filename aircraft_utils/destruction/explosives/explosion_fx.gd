extends Node3D

class_name ExplosionFX

@export var particles: Array[GPUParticles3D]
@export var light: OmniLight3D
@export var light_fade_time: float = 0.8
@export var audio_players: Array[AudioStreamPlayer3D]

var finished_count: int = 0

func increase_finished_count() -> void: finished_count += 1

func _ready() -> void:
	if light:
		var tween: Tween = create_tween()
		tween.tween_property(light, "light_energy", 0, light_fade_time)
	
	for i: GPUParticles3D in particles:
		i.emitting = true
		i.finished.connect(increase_finished_count)
	
	for i: AudioStreamPlayer3D in audio_players:
		i.play()
		i.finished.connect(increase_finished_count)
	

func _process(_delta: float) -> void:
	if finished_count == particles.size() + audio_players.size():
		if light and light.light_energy == 0:
			queue_free()
		
