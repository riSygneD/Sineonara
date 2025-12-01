class_name PlayerStats
extends Resource


signal health_changed(value : int)
signal max_health_changed(value : int)
signal energy_changed(value : float)
signal max_energy_changed(value : float)
signal no_health


@export var health : int = 6:
	set = set_health,
	get = get_health
@export var max_health : int = 6:
	set = set_max_health,
	get = get_max_health
@export var energy : float = 0.0:
	set = set_energy,
	get = get_energy
@export var max_energy : float = 6.0:
	set = set_max_energy,
	get = get_max_energy

func set_health(value : int) -> void:
	var target_value : int = mini(maxi(0, value), max_health)
	if health == target_value:
		return
	health = target_value
	health_changed.emit(target_value)
	if health <= 0:
		no_health.emit()

func set_max_health(value : int) -> void:
	if max_health == value:
		return
	max_health = value
	max_health_changed.emit(value)
	health = mini(health, max_health)

func set_energy(value : float) -> void:
	var target_value : float = minf(maxf(0, value), max_energy)
	if energy == target_value:
		return
	energy = target_value
	energy_changed.emit(target_value)

func set_max_energy(value : float) -> void:
	if max_energy == value:
		return
	max_energy = value
	max_energy_changed.emit(value)
	max_energy = minf(energy, max_energy)


func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_health

func get_energy() -> float:
	return energy

func get_max_energy() -> float:
	return max_energy

func _to_string() -> String:
	var dict : Dictionary[String, Variant] = {
		"health" : health,
		"max_health" : max_health,
		"energy" : energy,
		"max_energy" : max_energy
	}
	return str(dict)
