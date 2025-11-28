class_name CircleEnemy
extends Enemy


var radius : float = 12.0:
	set = set_radius
var circle_shape_2d : CircleShape2D:
	get:
		if not is_node_ready():
			return null
		return collision_shape_2d.get_shape() as CircleShape2D


@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


func _ready() -> void:
	circle_shape_2d.set_radius(radius)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)


func _draw() -> void:
	draw_colored_polygon(get_polygon(), Color.WHITE)
	#draw_circle(Vector2.ZERO, radius, Color.WHITE, true)


func set_radius(value : float) -> void:
	radius = value
	if is_node_ready():
		circle_shape_2d.set_radius(radius)


func get_polygon() -> PackedVector2Array:
	var points : Array[Vector2] = []
	var _num_points : int = 16
	var _angle : float = 0.0
	var _angle_step : float = TAU / _num_points
	points.resize(_num_points)
	for idx : int in _num_points:
		points.set(idx, Vector2.from_angle(_angle) * radius)
		_angle += _angle_step
	return PackedVector2Array(points)


func _on_screen_exited() -> void:
	print("hi owo")
