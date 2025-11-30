extends PanelContainer


const ENERGY_BAR_COLOR_BASE := Color.ORANGE
const ENERGY_RECHARGE_RATE_BASE : float = 0.5 # per second


var max_energy : float = 12.0
var energy : float = 0.0:
	set = set_energy,
	get = get_energy
var energy_recharge_rate : float = ENERGY_RECHARGE_RATE_BASE


@onready var energy_bar: ColorRect = %EnergyBar


func _ready() -> void:
	await get_tree().process_frame
	set_energy(max_energy)


func _physics_process(delta: float) -> void:
	energy += energy_recharge_rate * delta


func set_energy(value : float) -> void:
	var target_value : float = minf(maxf(0, value), max_energy)
	if energy == target_value:
		return
	energy = target_value
	var energy_ratio : float = energy / max_energy
	energy_bar.set_custom_minimum_size(Vector2(size.x * energy_ratio, 0))


func get_energy() -> float:
	return energy
	
