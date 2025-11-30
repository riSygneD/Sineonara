class_name PlayerPathController
extends Node


@export var player_path : PlayerPath


var player_stats : PlayerStats


func _enter_tree() -> void:
	if get_parent() is PlayerPath:
		player_path = get_parent()


func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)


func _unhandled_input(event: InputEvent) -> void:
	if not player_path or not event.is_pressed() or event.is_echo():
		return
	if event.is_action("attack"):
		var energy_cost : float = get_energy_cost()
		if player_stats.get_energy() >= energy_cost:
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
	elif event.is_action("debug"):
		player_path.collapse()
	else:
		return
	get_viewport().set_input_as_handled()

func get_energy_cost() -> float:
	var energy_cost : float = 12.0
	energy_cost += 6.0 * (player_path.get_amplitude_step_idx() + 1)
	energy_cost += 6.0 * (player_path.get_period_factor_step_idx() + 1)
	return energy_cost

func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
