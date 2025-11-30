class_name PlayerPath
extends Path2D


const IMPACT_SHIFT_SPEED_FACTOR : float = 6.75
const IMPACT_DURATION : float = 0.5
const BASE_SHIFT_SPEED_FACTOR : float = 0.5

const AMPLITUDE_STEPS : Array[float] = [40.0, 80.0, 120.0]
const PERIOD_FACTOR_STEPS : Array[float] = [16.0, 8.0, 4.0]


var _shift_speed_factor : float = BASE_SHIFT_SPEED_FACTOR
var _amplitude_step_idx : int = 0:
	set = set_amplitude_step_idx
var _period_factor_step_idx : int = 0:
	set = set_period_factor_step_idx
var _shift_speed_tween : Tween
var _amplitude_tween : Tween
var _period_tween : Tween


@onready var path_visualizer: PathVisualizer = %PathVisualizer


func _ready() -> void:
	_tween_amplitude_to(AMPLITUDE_STEPS.front())
	_tween_period_factor_to(PERIOD_FACTOR_STEPS.front())


func _physics_process(delta : float) -> void:
	var shift_by : float = curve.period * _shift_speed_factor * delta
	var projected_shift_x : float = curve.shift.x + shift_by
	curve.shift.x = fmod(projected_shift_x, curve.period)


func attack() -> void:
	var attack_path : Path2D = Path2D.new()
	var copied_curve : WaveCurve = curve.duplicate_deep(
			Resource.DEEP_DUPLICATE_ALL) as WaveCurve
	var attack_visualizer := PathEchoVisualizer.new()
	var attack_hitbox := PathHitbox.new()
	attack_path.set_curve(copied_curve)
	add_child(attack_path)
	attack_path.add_child(attack_visualizer)
	attack_path.add_child(attack_hitbox)
	attack_path.set_global_position(get_global_position())
	attack_visualizer.hidden.connect(attack_path.queue_free)
	
	if _shift_speed_tween:
		_shift_speed_tween.pause()
		_shift_speed_tween.custom_step(IMPACT_DURATION)
		_shift_speed_tween.kill()
	_shift_speed_factor = IMPACT_SHIFT_SPEED_FACTOR
	_shift_speed_tween = create_tween().set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_OUT)
	_shift_speed_tween.tween_property(self, "_shift_speed_factor",
			BASE_SHIFT_SPEED_FACTOR, IMPACT_DURATION)


func decrease_amplitude() -> void:
	set_amplitude_step_idx(maxi(0, _amplitude_step_idx - 1))

func increase_amplitude() -> void:
	set_amplitude_step_idx(mini(AMPLITUDE_STEPS.size() - 1,
			_amplitude_step_idx + 1))

func decrease_frequency() -> void:
	set_period_factor_step_idx(maxi(0, _period_factor_step_idx - 1))

func increase_frequency() -> void:
	set_period_factor_step_idx(mini(PERIOD_FACTOR_STEPS.size() - 1,
			_period_factor_step_idx + 1))


func set_amplitude_step_idx(value : int) -> void:
	_amplitude_step_idx = value
	if is_inside_tree():
		_tween_amplitude_to(AMPLITUDE_STEPS.get(_amplitude_step_idx))


func set_period_factor_step_idx(value : int) -> void:
	_period_factor_step_idx = value
	if is_inside_tree():
		_tween_period_factor_to(PERIOD_FACTOR_STEPS.get(_period_factor_step_idx))


func _tween_amplitude_to(value : float) -> void:
	if _amplitude_tween:
		_amplitude_tween.pause()
		_amplitude_tween.custom_step(0.2)
		_amplitude_tween.kill()
	if is_equal_approx(curve.amplitude, value):
		return
	_amplitude_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	_amplitude_tween.tween_property(curve, "amplitude", value, 0.2)


func _tween_period_factor_to(value : float) -> void:
	if _period_tween:
		_period_tween.pause()
		_period_tween.custom_step(0.2)
		_period_tween.kill()
	if is_equal_approx(curve.period_factor, value):
		return
	_period_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	_period_tween.tween_property(curve, "period_factor", value, 0.2)


func collapse() -> void:
	var collapse_tween : Tween = create_tween().set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT).set_parallel()
	collapse_tween.tween_property(curve, "maximum_x",
			0, 2.0)
	collapse_tween.tween_property(curve, "period_factor",
			curve.period_factor * 0.5, 2.0)
	collapse_tween.tween_property(curve, "amplitude",
			curve.amplitude * 2.0, 0.5)
	collapse_tween.tween_property(curve, "amplitude",
			0.0, 1.5).set_delay(0.5)
