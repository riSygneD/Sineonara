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
		player_path.attack()
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

func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
	print(player_stats)
