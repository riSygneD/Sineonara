@tool
class_name WavePathExample
extends Path2D

@export_tool_button("Expand Wave Curve") var callable : Callable = expand_wave_curve

func expand_wave_curve() -> void:
	if not curve or curve is not WaveCurve:
		return
	#scale.x = 0.0
	#(curve as WaveCurve).set_maximum_x(640.0)
	var tween : Tween = create_tween().set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "scale:x", 1.0, 0.5).from(0.0)
	tween.tween_property(curve as WaveCurve, "maximum_x", 640.0, 0.5).from(0.0)
