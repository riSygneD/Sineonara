class_name EnemySpawner
extends Node2D

const BASIC_ENEMY = preload("uid://chslile3hjjx2")

const SPAWN_Y_OFFSETS : Array[float] = [-120.0, -80.0, -40.0, 0.0, 40.0, 80.0, 120.0]
const SPAWN_WEIGHTS : Array[float] = [2, 3, 4, 6, 4, 3, 2]
const SPAWN_Y_RANDOM_MAX : float = 6.0

@onready var rng := RandomNumberGenerator.new()

func spawn_enemy() -> void:
	var base_roll : int = rng.rand_weighted(SPAWN_WEIGHTS)
	var y_offset : float = SPAWN_Y_OFFSETS.get(base_roll)
	y_offset += rng.randf_range(-SPAWN_Y_RANDOM_MAX, SPAWN_Y_RANDOM_MAX)
	var spawn_global_pos : Vector2 = get_global_position() + Vector2.DOWN * y_offset
	var new_enemy := BASIC_ENEMY.instantiate()
	add_sibling(new_enemy)
	new_enemy.set_global_position(spawn_global_pos)
