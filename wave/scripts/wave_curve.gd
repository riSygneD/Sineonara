@tool
class_name WaveCurve
extends Curve2D


signal parameter_changed


@export_tool_button("Clear Points") var clear_points_callable : Callable = clear_points
@export var generate_wave_on_parameter_change : bool = false:
	set = set_generate_wave_on_parameter_change


@export_group("Parameters")
@export var minimum_x : float = 0.0:
	set = set_minimum_x
@export var maximum_x : float = 640.0:
	set = set_maximum_x
@export var amplitude : float = 180.0:
	set = set_amplitude
@export_range(1.0, 64.0) var period_factor : float = 4.0:
	set = set_period_factor
@export var shift : Vector2 = Vector2.ZERO:
	set = set_shift
@export_range(2.0, 8.0) var accuracy_factor : int = 4:
	set = set_accuracy_factor


var a : float:
	get: return amplitude
var b : float:
	get: return (TAU / 16) / period_factor
var c : float:
	get: return shift.x
var d : float:
	get: return shift.y
var period : float:
	get: return TAU / b
var wave_generation_queued : bool = false


func _init() -> void:
	parameter_changed.connect(_on_parameter_changed)


func set_generate_wave_on_parameter_change(value : bool) -> void:
	generate_wave_on_parameter_change = value
	if value:
		generate_wave()


func set_minimum_x(value : float) -> void:
	minimum_x = value
	parameter_changed.emit()


func set_maximum_x(value : float) -> void:
	maximum_x = value
	parameter_changed.emit()


func set_amplitude(value : float) -> void:
	amplitude = value
	parameter_changed.emit()

func set_period_factor(value : float) -> void:
	period_factor = value
	parameter_changed.emit()

func set_shift(value : Vector2) -> void:
	shift = value
	parameter_changed.emit()

func set_accuracy_factor(value : int) -> void:
	accuracy_factor = value
	parameter_changed.emit()


func generate_wave() -> void:
	clear_points()
	@warning_ignore("narrowing_conversion")
	var num_period_divisions : int = roundi(pow(2, accuracy_factor))
	var division_length : float = period / num_period_divisions
	var x : float = minimum_x
	add_point(calculate_point(minimum_x))
	while x < maximum_x - division_length:
		x += division_length
		add_point(calculate_point(x))
	add_point(calculate_point(maximum_x))


func calculate_point(x : float) -> Vector2:
	return Vector2(x, a * sin(b * (x + c)) + d)


func _on_parameter_changed() -> void:
	if generate_wave_on_parameter_change:
		generate_wave()
