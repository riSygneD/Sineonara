class_name WaveInfo
extends Resource


@export var num_enemies : int = 12
@export var spawn_time : float = 1.0

func _init(_num_enemies : int = 12, _spawn_time : float = 1.0) -> void:
	num_enemies = _num_enemies
	spawn_time = _spawn_time
