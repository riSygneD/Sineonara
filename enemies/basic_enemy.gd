class_name BasicEnemy
extends Enemy

var spawn_with_random_shape : bool = true
var spawn_with_random_angle_offset : bool = true

@onready var basic_collision_polygon: BasicCollisionPolygon = %BasicCollisionPolygon
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


func _draw() -> void:
	if is_node_ready():
		draw_colored_polygon(get_polygon(), Color.WHITE)


func _ready() -> void:
	if spawn_with_random_shape:
		basic_collision_polygon.set_random_shape()
		queue_redraw()
	if spawn_with_random_angle_offset:
		basic_collision_polygon.set_random_angle_offset()
		queue_redraw()
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)


func get_polygon() -> PackedVector2Array:
	if not is_node_ready():
		return []
	return basic_collision_polygon.get_polygon()


func _on_screen_exited() -> void:
	SignalBus.enemy_reached_left.emit()
