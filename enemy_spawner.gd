class_name EnemySpawner
extends Path2D

const BASIC_ENEMY = preload("uid://chslile3hjjx2")

func spawn_enemy() -> void:
	var random_weight : float = randf()
	print(random_weight)
	var random_offset : float = lerpf(0.0, curve.get_baked_length(), random_weight)
	var spawn_local_pos : Vector2 = curve.sample_baked(random_offset)
	var spawn_global_pos : Vector2 = get_global_position() + spawn_local_pos
	var new_enemy := BASIC_ENEMY.instantiate()
	add_sibling(new_enemy)
	new_enemy.set_global_position(spawn_global_pos)
	pass
