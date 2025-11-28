extends Path2D


const IMPACT_SHIFT_SPEED_FACTOR : float = 6.75
const IMPACT_DURATION : float = 0.5
const BASE_SHIFT_SPEED_FACTOR : float = 0.5

const AMPLITUDE_STEPS : Array[float] = [40.0, 80.0, 120.0]
const PERIOD_FACTOR_STEPS : Array[float] = [16.0, 8.0, 4.0]


var shift_speed_factor : float = BASE_SHIFT_SPEED_FACTOR
var amplitude_step_idx : int = 0:
	set = set_amplitude_step_idx
var period_factor_step_idx : int = 0:
	set = set_period_factor_step_idx
var shift_speed_tween : Tween
var amplitude_tween : Tween
var period_tween : Tween


@onready var path_visualizer: PathVisualizer = %PathVisualizer


func _ready() -> void:
	tween_amplitude_to(AMPLITUDE_STEPS.front())
	tween_period_factor_to(PERIOD_FACTOR_STEPS.front())


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	if event.is_action("attack"):
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
		
		if shift_speed_tween:
			shift_speed_tween.pause()
			shift_speed_tween.custom_step(IMPACT_DURATION)
			shift_speed_tween.kill()
		shift_speed_factor = IMPACT_SHIFT_SPEED_FACTOR
		shift_speed_tween = create_tween().set_trans(Tween.TRANS_CUBIC)\
				.set_ease(Tween.EASE_OUT)
		shift_speed_tween.tween_property(self, "shift_speed_factor",
				BASE_SHIFT_SPEED_FACTOR, IMPACT_DURATION)
	
	elif event.is_action("decrease_amplitude"):
		set_amplitude_step_idx(maxi(0, amplitude_step_idx - 1))
	
	elif event.is_action("increase_amplitude"):
		set_amplitude_step_idx(mini(AMPLITUDE_STEPS.size() - 1,
				amplitude_step_idx + 1))
	
	elif event.is_action("decrease_frequency"):
		set_period_factor_step_idx(maxi(0, period_factor_step_idx - 1))
	
	elif event.is_action("increase_frequency"):
		set_period_factor_step_idx(mini(PERIOD_FACTOR_STEPS.size() - 1,
				period_factor_step_idx + 1))
	
	elif event.is_action("debug"):
		collapse()
	
	else:
		return
	get_viewport().set_input_as_handled()


func _physics_process(delta : float) -> void:
	var shift_by : float = curve.period * shift_speed_factor * delta
	var projected_shift_x : float = curve.shift.x + shift_by
	curve.shift.x = fmod(projected_shift_x, curve.period)


func set_amplitude_step_idx(value : int) -> void:
	amplitude_step_idx = value
	if is_inside_tree():
		tween_amplitude_to(AMPLITUDE_STEPS.get(amplitude_step_idx))


func set_period_factor_step_idx(value : int) -> void:
	period_factor_step_idx = value
	if is_inside_tree():
		tween_period_factor_to(PERIOD_FACTOR_STEPS.get(period_factor_step_idx))


func tween_amplitude_to(value : float) -> void:
	if amplitude_tween:
		amplitude_tween.pause()
		amplitude_tween.custom_step(0.2)
		amplitude_tween.kill()
	if is_equal_approx(curve.amplitude, value):
		return
	amplitude_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	amplitude_tween.tween_property(curve, "amplitude", value, 0.2)


func tween_period_factor_to(value : float) -> void:
	if period_tween:
		period_tween.pause()
		period_tween.custom_step(0.2)
		period_tween.kill()
	if is_equal_approx(curve.period_factor, value):
		return
	period_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	period_tween.tween_property(curve, "period_factor", value, 0.2)


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
