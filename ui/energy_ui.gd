extends PanelContainer


var player_stats : PlayerStats
var energy : float:
	get: return player_stats.get_energy()
var max_energy : float:
	get: return player_stats.get_max_energy()




@onready var energy_bar: ColorRect = %EnergyBar


func _ready() -> void:
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)
	resized.connect(_on_resized)


func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
	if not player_stats:
		return
	player_stats.energy_changed.connect(_on_energy_changed)
	_on_energy_changed(player_stats.get_energy())


func _on_energy_changed(value : float) -> void:
	var energy_ratio : float = value / max_energy
	energy_bar.set_custom_minimum_size(Vector2(size.x * energy_ratio, 0))

func _on_resized() -> void:
	if player_stats:
		_on_energy_changed(player_stats.get_energy())
	
