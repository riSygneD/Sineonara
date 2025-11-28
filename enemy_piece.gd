class_name EnemyPiece
extends Node2D

const DURATION : float = 0.5
const BASE_LAUNCH_SPEED : float = 128.0


var launch_speed : float = BASE_LAUNCH_SPEED
var launch_direction : Vector2 = Vector2.ZERO:
	set = set_launch_direction
var polygon : PackedVector2Array
var center : Vector2


func _draw() -> void:
	draw_colored_polygon(polygon, Color.ORANGE)


func _init(p_polygon : PackedVector2Array) -> void:
	set_as_top_level(true)
	
	_generate_from_polygon(p_polygon)
	
	#var notifier := VisibleOnScreenNotifier2D.new()
	#add_child(notifier)
	#notifier.screen_exited.connect(queue_free)


func _ready() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DURATION)
	tween.tween_property(self, "launch_speed", 0.0, DURATION)
	tween.finished.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += launch_direction * launch_speed * delta


func set_launch_direction(value : Vector2) -> void:
	launch_direction = value.normalized()


func _generate_from_polygon(p_polygon : PackedVector2Array) -> void:
	var sum : Vector2 = Vector2.ZERO
	for vec2 : Vector2 in p_polygon:
		sum += vec2
	center = sum / p_polygon.size()
	var new_points : Array[Vector2] = []
	for vec2 : Vector2 in p_polygon: 
		new_points.push_back(vec2 - center)
	polygon = new_points as PackedVector2Array
	ready.connect(set_global_position.bind(center))
