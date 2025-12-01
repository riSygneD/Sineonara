class_name PlayerPathController
extends Node


@export var player_path : PlayerPath


var player_stats : PlayerStats
var active : bool = false

func _enter_tree() -> void:
	if get_parent() is PlayerPath:
		player_path = get_parent()


func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)


func _unhandled_input(event: InputEvent) -> void:
	if not active or not player_path or not event.is_pressed() or event.is_echo():
		return
	if event.is_action("attack"):
		var energy_cost := player_path.get_energy_cost()
		if player_stats.get_energy() >= player_path.get_energy_cost():
			player_path.attack()
			player_stats.energy -= energy_cost
	elif event.is_action("decrease_amplitude"):
		player_path.decrease_amplitude()
	elif event.is_action("increase_amplitude"):
		player_path.increase_amplitude()
	elif event.is_action("decrease_frequency"):
		player_path.decrease_frequency()
	elif event.is_action("increase_frequency"):
		player_path.increase_frequency()
	else:
		return
	get_viewport().set_input_as_handled()


func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
	if not player_stats:
		return
	player_stats.no_health.connect(func():
		active = false
	)
	active = true
