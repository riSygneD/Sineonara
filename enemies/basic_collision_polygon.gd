@tool
class_name BasicCollisionPolygon
extends CollisionPolygon2D


enum Shape {
	TRIANGLE=3, ## Three sided shape.
	QUAD=4, ## Four sided shape.
	CIRCLE=12 ## Looks close enough to a circle at lowres.
}

@export_tool_button("Set Random Angle Offset") var btn_angle : Callable = set_random_angle_offset
@export_tool_button("Set Random Shape") var btn_shape : Callable = set_random_shape
@export var shape : Shape = Shape.CIRCLE:
	set = set_shape
@export_group("Fine Parameters")
@export var num_points : int = 3:
	set = set_num_points
@export_range(0.0, TAU, PI / 4) var angle_offset : float = 0.0:
	set = set_angle_offset
@export var radius : float = 12.0:
	set = set_radius


@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


func _ready() -> void:
	update_polygon()


func set_shape(value : Shape) -> void:
	shape = value
	set_num_points(shape as int)


func set_num_points(value : int) -> void:
	num_points = value
	update_polygon()


func set_angle_offset(value : float) -> void:
	angle_offset = value
	update_polygon()


func set_radius(value : float) -> void:
	radius = value
	update_polygon()

func set_random_shape() -> void:
	set_shape(Shape.values().pick_random())

func set_random_angle_offset() -> void:
	set_angle_offset(randf_range(0, TAU))


func update_polygon() -> PackedVector2Array:
	var points : Array[Vector2] = []
	var _angle : float = angle_offset
	var _angle_step : float = TAU / num_points
	points.resize(num_points)
	for idx : int in num_points:
		points.set(idx, Vector2.from_angle(_angle) * radius)
		_angle += _angle_step
	polygon = PackedVector2Array(points)
	return polygon
