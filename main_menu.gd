class_name MainMenu
extends Control


signal game_start_requested


@onready var play_button: Button = %PlayButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)


func _on_play_button_pressed() -> void:
	play_button.set_disabled(true)
	game_start_requested.emit()
