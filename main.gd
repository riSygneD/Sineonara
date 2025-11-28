extends Node


const MAIN_MENU = preload("uid://daudfjxicymcy")
const GAME_UID = "uid://dw88n4b32l7vi"


var fade_tween : Tween

@onready var fade_overlay: ColorRect = %FadeOverlay


func _init() -> void:
	child_entered_tree.connect(_on_child_entered_tree)


func _ready() -> void:
	var main_menu : MainMenu = MAIN_MENU.instantiate() as MainMenu
	add_child(main_menu)


func _on_child_entered_tree(child : Node) -> void:
	if child is MainMenu:
		child.game_start_requested.connect(_on_game_start_requested.bind(child), CONNECT_ONE_SHOT)


func _on_game_start_requested(main_menu : MainMenu = null) -> void:
	ResourceLoader.load_threaded_request(GAME_UID)
	
	await fade_out()
	
	main_menu.queue_free()
	
	var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(GAME_UID)
	while status != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		await get_tree().physics_frame
		status = ResourceLoader.load_threaded_get_status(GAME_UID)
	
	var game_scene : PackedScene = ResourceLoader.load_threaded_get(GAME_UID) as PackedScene
	var game_node : Node = game_scene.instantiate()
	add_child(game_node)
	
	await fade_in()
	
	print("game should be loaded and visible! :3")


func fade_in(duration : float = 1.0) -> Signal:
	return fade(0.0, duration)

func fade_out(duration : float = 1.0) -> Signal:
	return fade(1.0, duration)

func fade(alpha : float, duration : float = 1.0) -> Signal:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade_tween.tween_property(fade_overlay, "color:a", alpha, duration)
	return fade_tween.finished
