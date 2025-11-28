@warning_ignore("missing_tool")
class_name PathEchoVisualizer
extends PathVisualizer

func _ready() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "width", 6.0, 0.35)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.35)
	tween.finished.connect(hide)
