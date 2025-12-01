class_name MainMenu
extends Control


signal game_start_requested


var static_tween : Tween


@onready var play_button: Button = %PlayButton
@onready var static_noise_player: StaticNoisePlayer = %StaticNoisePlayer


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	if static_tween:
		static_tween.kill()
	static_tween = create_tween()
	static_tween.tween_property(static_noise_player, "volume_linear", 1.0, 3.0)


func _on_play_button_pressed() -> void:
	play_button.set_disabled(true)
	game_start_requested.emit()
	if static_tween:
		static_tween.kill()
	static_tween = create_tween()
	static_tween.tween_property(static_noise_player, "volume_linear", 0.0, 0.5)
