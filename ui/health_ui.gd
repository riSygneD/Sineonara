extends PanelContainer


signal health_restored
signal damage_taken


const HEALTH_BAR_COLOR_BASE : Color = Color.RED
const HEALTH_BAR_COLOR_HEAL : Color = Color.GREEN
const HEALTH_BAR_COLOR_DAMAGED : Color = Color.WHITE
const TWEEN_DELAY : float = 0.75
const TWEEN_DURATION : float = 0.5


var player_stats : PlayerStats
var last_health : int = 0
var tween : Tween

var health : int:
	get: return player_stats.get_health()
var max_health : int:
	get: return player_stats.get_max_health()
	

@onready var health_bar_over: ColorRect = %HealthBarOver
@onready var health_bar_under: ColorRect = %HealthBarUnder


func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)
	health_restored.connect(_on_health_restored)
	damage_taken.connect(_on_damage_taken)
	await get_tree().process_frame
	health_bar_over.set_custom_minimum_size(size)
	health_bar_under.set_custom_minimum_size(size)


func new_tween() -> Tween:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)#.set_ease(Tween.EASE_IN)
	return tween


func _on_damage_taken() -> void:
	var health_ratio : float = float(health) / max_health
	var target_size_x : float = size.x * health_ratio
	
	health_bar_over.set_color(HEALTH_BAR_COLOR_BASE)
	health_bar_over.set_custom_minimum_size(Vector2(target_size_x, 0.0))
	
	health_bar_under.set_color(HEALTH_BAR_COLOR_DAMAGED)
	new_tween().tween_property(health_bar_under, "custom_minimum_size:x",
			target_size_x, TWEEN_DURATION).set_delay(TWEEN_DELAY)


func _on_health_restored() -> void:
	var health_ratio : float = float(health) / max_health
	var target_size_x : float = size.x * health_ratio
	
	health_bar_under.set_color(HEALTH_BAR_COLOR_HEAL)
	health_bar_under.set_custom_minimum_size(Vector2(target_size_x, 0.0))
	
	health_bar_over.set_color(HEALTH_BAR_COLOR_BASE)
	new_tween().tween_property(health_bar_over, "custom_minimum_size:x",
			target_size_x, TWEEN_DURATION).set_delay(TWEEN_DELAY)


func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
	if not player_stats:
		return
	last_health = player_stats.health
	player_stats.health_changed.connect(_on_health_changed)


func _on_health_changed(value : int) -> void:
	if value > last_health:
		health_restored.emit()
	elif value < last_health:
		damage_taken.emit()
	last_health = value
