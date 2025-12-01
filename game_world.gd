class_name GameWorld
extends Node2D


signal wave_updated(wave_info : WaveInfo)
signal wave_enemies_remaining_updated
signal wave_finished


const GAME_OVER_UID = "uid://da0h5pqfitjqn"

var wave_info : WaveInfo = WaveInfo.new(10, 1.4):
	get = get_wave_info
var wave_enemies_remaining : int = 0:
	get = get_wave_enemies_remaining,
	set = set_wave_enemies_remaining
var player_stats : PlayerStats

@onready var start_timer: Timer = %StartTimer
@onready var spawn_timer: Timer = %SpawnTimer
@onready var wave_timer: Timer = %WaveTimer
@onready var enemy_spawner: EnemySpawner = %EnemySpawner


func _ready() -> void:
	wave_finished.connect(_on_wave_finished)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	start_timer.timeout.connect(func():
		start_game()
		start_timer.queue_free()
	)
	wave_timer.timeout.connect(start_next_wave)


func get_wave_info() -> WaveInfo:
	return wave_info

func get_wave_enemies_remaining() -> int:
	return wave_enemies_remaining

func set_wave_enemies_remaining(value : int) -> void:
	wave_enemies_remaining = value
	wave_enemies_remaining_updated.emit(value)


func _on_spawn_timer_timeout() -> void:
	if wave_enemies_remaining > 0:
		enemy_spawner.spawn_enemy()
		wave_enemies_remaining -= 1
	else:
		wave_finished.emit()
		spawn_timer.stop()


func _on_wave_finished() -> void:
	if is_equal_approx(wave_info.spawn_time, 1.0):
		wave_info.num_enemies += 10
	else:
		wave_info.num_enemies += 5
		
	var difficulty_mod : int = maxi(0, wave_info.num_enemies - 20) % 20
	match difficulty_mod:
		0:
			enemy_spawner.set_difficulty(EnemySpawner.Difficulty.EASY)
		1:
			enemy_spawner.set_difficulty(EnemySpawner.Difficulty.MEDIUM)
		_:
			enemy_spawner.set_difficulty(EnemySpawner.Difficulty.HARD)
	
	wave_info.spawn_time = maxf(1.0, wave_info.spawn_time - 0.2)
	
	wave_updated.emit(wave_info)
	wave_timer.start(5.0)


func start_game() -> void:
	print("game should start...")
	var p_player_stats := PlayerStats.new()
	SignalBus.player_stats_initialized.emit(p_player_stats)
	player_stats = p_player_stats
	player_stats.no_health.connect(_on_no_health)
	
	start_next_wave()


func start_next_wave() -> void:
	wave_enemies_remaining = wave_info.num_enemies
	spawn_timer.start(wave_info.spawn_time)
	player_stats.set_health(player_stats.get_health() + 1)


func _on_no_health() -> void:
	ResourceLoader.load_threaded_request(GAME_OVER_UID)
	
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT).set_ignore_time_scale(true)
	tween.tween_property(Engine, "time_scale", 0.0, 0.75)
	tween.tween_callback(get_tree().set_pause.bind(true))
	await tween.finished
	
	var status : ResourceLoader.ThreadLoadStatus\
			 = ResourceLoader.load_threaded_get_status(GAME_OVER_UID)
	while status != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		await get_tree().physics_frame
		status = ResourceLoader.load_threaded_get_status(GAME_OVER_UID)
	
	var game_over_scene : PackedScene\
			 = ResourceLoader.load_threaded_get(GAME_OVER_UID) as PackedScene
	var game_over_node : Node = game_over_scene.instantiate()
	var main_node : Node = get_tree().get_first_node_in_group("main")
	main_node.add_child(game_over_node)
