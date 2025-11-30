extends PanelContainer


signal health_restored
signal damage_taken


const HEALTH_BAR_COLOR_BASE : Color = Color.RED
const HEALTH_BAR_COLOR_HEAL : Color = Color.GREEN
const HEALTH_BAR_COLOR_DAMAGED : Color = Color.YELLOW
const TWEEN_DELAY : float = 0.75
const TWEEN_DURATION : float = 0.5


var max_health : int = 6
var health : int = 6:
	set = set_health,
	get = get_health
var tween : Tween


@onready var health_bar_over: ColorRect = %HealthBarOver
@onready var health_bar_under: ColorRect = %HealthBarUnder


func _ready() -> void:
	SignalBus.enemy_reached_left.connect(take_damage.bind(1))
	health_restored.connect(_on_health_restored)
	damage_taken.connect(_on_damage_taken)
	await get_tree().process_frame
	health_bar_over.set_custom_minimum_size(size)
	health_bar_under.set_custom_minimum_size(size)


func take_damage(value : int) -> void:
	health -= value


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


func set_health(value : int) -> void:
	var original_value : int = health
	var target_value : int = mini(maxi(0, value), max_health)
	if original_value == target_value:
		return
	health = target_value
	if original_value < health:
		health_restored.emit()
	else:
		damage_taken.emit()

func get_health() -> int:
	return health
