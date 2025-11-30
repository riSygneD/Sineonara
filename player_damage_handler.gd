class_name PlayerDamageHandler
extends Node


var player_stats : PlayerStats


func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)
	SignalBus.enemy_reached_left.connect(take_damage)


func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats


func take_damage() -> void:
	if not player_stats:
		print_debug("ERROR: Player stats was not initialized for me!")
		return
	player_stats.health -= 1
