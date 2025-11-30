extends Node2D

@onready var spawn_timer: Timer = %SpawnTimer
@onready var enemy_spawner: EnemySpawner = %EnemySpawner

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	await get_tree().create_timer(1.0, false, true).timeout
	start_game()

func _on_spawn_timer_timeout() -> void:
	enemy_spawner.spawn_enemy()

func start_game() -> void:
	var player_stats := PlayerStats.new()
	SignalBus.player_stats_initialized.emit(player_stats)
	
	spawn_timer.start()
