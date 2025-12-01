extends Control

const WAVE_INFO_FORMAT = "Wave Info\n\nRemaining\n%d\nTotal\n%d\nSpawn Rate\n%.1f"

@onready var game_world: GameWorld = %GameWorld
@onready var wave_info_label: Label = %WaveInfoLabel

func _ready() -> void:
	game_world.wave_updated.connect(_on_wave_updated)
	game_world.wave_enemies_remaining_updated.connect(_on_wave_enemies_remaining_updated)
	_on_wave_updated(game_world.get_wave_info())

func _on_wave_enemies_remaining_updated(value : int) -> void:
	var wave_info := game_world.get_wave_info()
	wave_info_label.set_text(WAVE_INFO_FORMAT % [
		value,
		wave_info.num_enemies,
		wave_info.spawn_time
	])
func _on_wave_updated(wave_info : WaveInfo) -> void:
	wave_info_label.set_text(WAVE_INFO_FORMAT % [
		game_world.get_wave_enemies_remaining(),
		wave_info.num_enemies,
		wave_info.spawn_time
	])
