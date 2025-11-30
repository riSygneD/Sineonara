extends Node2D

const SHIFT_SPEED : float = 32.0

@onready var wave_test: Path2D = %WaveTest
@onready var wave_test_curve : WaveCurve = wave_test.get_curve() as WaveCurve

func _process(delta : float) -> void:
	wave_test_curve.shift.x = fmod(wave_test_curve.shift.x + SHIFT_SPEED * delta, wave_test_curve.period)
