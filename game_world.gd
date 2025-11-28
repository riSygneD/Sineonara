extends Node2D

@onready var spawn_timer: Timer = %SpawnTimer
@onready var enemy_spawner: EnemySpawner = %EnemySpawner

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	enemy_spawner.spawn_enemy()
