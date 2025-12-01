@tool
class_name PlayerPathVisualizer
extends PathVisualizer

const ENERGY_VALID := Color.ORANGE
const ENERGY_INVALID := Color.WHITE

var player_stats : PlayerStats

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SignalBus.player_stats_initialized.connect(_on_player_stats_initialized)
	set_modulate(ENERGY_INVALID)

func _on_player_stats_initialized(p_player_stats : PlayerStats) -> void:
	player_stats = p_player_stats
	if not player_stats:
		return
	player_stats.energy_changed.connect(_on_energy_changed)

func _on_energy_changed(value : float) -> void:
	if not path or path is not PlayerPath:
		return
	if path is PlayerPath:
		if value < path.get_energy_cost():
			set_modulate(ENERGY_INVALID)
		else:
			set_modulate(ENERGY_VALID)
