class_name PlayerAudioHandler
extends Node


const HURT = preload("uid://cmndcycc1ofjg")
const ATTACK = preload("uid://hu2k336igh7v")


@export var player_path : PlayerPath
@export var player_damage_handler : PlayerDamageHandler


func _ready() -> void:
	if player_path:
		player_path.attacked.connect(play_attack_sound)
	if player_damage_handler:
		player_damage_handler.damage_taken.connect(play_hurt_sound)


func play_attack_sound(amplitude_step : int, frequency_step : int) -> void:
	var audio_player := new_audio_player(ATTACK.duplicate())
	audio_player.volume_linear *= 0.8 + (amplitude_step * 0.2)
	audio_player.pitch_scale *= 0.75 + (frequency_step * 0.25)
	add_child(audio_player)


func play_hurt_sound() -> void:
	var audio_player := new_audio_player(HURT.duplicate())
	add_child(audio_player)


func new_audio_player(audio_stream : AudioStream) -> AudioStreamPlayer:
	var audio_player := AudioStreamPlayer.new()
	audio_player.set_stream(audio_stream)
	audio_player.set_autoplay(true)
	audio_player.finished.connect(audio_player.queue_free)
	return audio_player
	
	
