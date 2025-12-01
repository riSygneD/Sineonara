class_name GameOverScreen
extends Control


signal main_menu_requested


@onready var main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed() -> void:
	main_menu_button.set_disabled(true)
	main_menu_requested.emit()
