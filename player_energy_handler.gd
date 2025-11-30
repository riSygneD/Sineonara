class_name PlayerEnergyHandler
extends Node

const ENERGY_RECHARGE_RATE := 6.0 # per second

var player_stats : PlayerStats

func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)

func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats

func _physics_process(delta: float) -> void:
	if not player_stats:
		return
	var energy_delta : float = ENERGY_RECHARGE_RATE * delta
	player_stats.set_energy(player_stats.get_energy() + energy_delta)
