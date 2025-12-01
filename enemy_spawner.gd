class_name EnemySpawner
extends Node2D

enum Difficulty {
	EASY, MEDIUM, HARD
}

@export var difficulty : Difficulty = Difficulty.EASY:
	set = set_difficulty

const BASIC_ENEMY = preload("uid://chslile3hjjx2")

const SPAWN_Y_OFFSETS : Array[float] = [-120.0, -80.0, -40.0, 0.0, 40.0, 80.0, 120.0]
const SPAWN_Y_RANDOM_MAX : float = 6.0
const DIFFICULTY_OFFSET_COUNTS : Dictionary[Difficulty, Array] = {
	Difficulty.EASY : [2, 3, 4, 6, 4, 3, 2],
	Difficulty.MEDIUM : [3, 5, 5, 6, 5, 5, 3],
	Difficulty.HARD : [4, 6, 6, 6, 6, 6, 4]
}

var bag : Array[float] = []

@onready var rng := RandomNumberGenerator.new()

func spawn_enemy() -> void:
	if bag.size() <= 0:
		bag = get_current_difficulty_bag()
	var y_offset : float = bag.pop_at(randi_range(0, bag.size() - 1))
	y_offset += rng.randf_range(-SPAWN_Y_RANDOM_MAX, SPAWN_Y_RANDOM_MAX)
	var spawn_global_pos : Vector2 = get_global_position() + Vector2.DOWN * y_offset
	var new_enemy := BASIC_ENEMY.instantiate()
	add_sibling(new_enemy)
	new_enemy.set_global_position(spawn_global_pos)

func increase_difficulty() -> void:
	match difficulty:
		Difficulty.MEDIUM:
			difficulty = Difficulty.HARD
		Difficulty.EASY:
			difficulty = Difficulty.MEDIUM

func set_difficulty(value : Difficulty) -> void:
	difficulty = value

func get_current_difficulty_bag() -> Array[float]:
	var difficulty_offset_count : Array = DIFFICULTY_OFFSET_COUNTS.get(difficulty, [])
	if difficulty_offset_count is not Array:
		return []
	assert(difficulty_offset_count as Array[int])
	var new_bag : Array[float] = []
	for idx : int in difficulty_offset_count.size():
		var offset : float = SPAWN_Y_OFFSETS.get(idx)
		var count : int = difficulty_offset_count.get(idx)
		for _idx : int in count:
			new_bag.push_back(offset)
	return new_bag
