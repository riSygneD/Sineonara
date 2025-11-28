@tool
class_name PathHitbox
extends Area2D


@export_tool_button("Clear Collision Shapes") var c1 : Callable = clear_collision_shapes
@export_tool_button("Generate Collision Shapes") var c2 : Callable = generate_collision_shapes
@export var path : Path2D:
	set = set_path
@export_range(2.0, 8.0, 1.0) var width : float = 2.0:
	set = set_width


var used_points : Array[Vector2] = []


func _init() -> void:
	set_collision_layer(0)
	set_collision_mask(1)
	tree_entered.connect(_on_tree_entered)
	area_entered.connect(_on_area_entered)


func set_path(value : Path2D) -> void:
	path = value
	generate_collision_shapes()


func set_width(value : float) -> void:
	width = value
	generate_collision_shapes()


func generate_collision_shapes() -> void:
	clear_collision_shapes()
	if not path:
		return
	var curve : Curve2D = path.get_curve()
	if not curve:
		return
	
	var num_points : int = curve.get_point_count()
	if num_points <= 1:
		return
	
	var num_shapes : int = num_points - 1
	var point_a : Vector2 = curve.get_point_position(0)
	used_points.push_back(point_a)
	for shape_idx : int in num_shapes:
		var point_b : Vector2 = curve.get_point_position(shape_idx + 1)
		used_points.push_back(point_b)
		var a_to_b : Vector2 = point_b - point_a
		var shape_height : float = a_to_b.length()
		var collision_center : Vector2 = point_a + (a_to_b / 2)
		var collision_rotation : float = a_to_b.angle() + PI / 2
		
		var shape : CapsuleShape2D = CapsuleShape2D.new()
		shape.set_height(shape_height)
		shape.set_radius(width)
		
		var collision : CollisionShape2D = CollisionShape2D.new()
		collision.set_shape(shape)
		add_child(collision)
		collision.set_rotation(collision_rotation)
		collision.set_position(collision_center)
		
		point_a = point_b


func clear_collision_shapes() -> void:
	for child : Node in get_children(true):
		if child is CollisionShape2D:
			child.queue_free()


func get_global_polyline() -> PackedVector2Array:
	return Transform2D(0, get_global_position()) * PackedVector2Array(used_points)


func cut_enemy(enemy : Enemy) -> void:
	var enemy_global_pos : Vector2 = enemy.get_global_position()
	
	var polyline : PackedVector2Array = get_global_polyline()
	var polygon : PackedVector2Array = enemy.get_global_polygon()
	var clipping_polygons := Geometry2D.offset_polyline(polyline, width)
	for clipping_polygon : PackedVector2Array in clipping_polygons:
		var clipped_polygons := Geometry2D.clip_polygons(polygon, clipping_polygon)
		for clipped_polygon : PackedVector2Array in clipped_polygons:
			var new_piece := EnemyPiece.new(clipped_polygon)
			new_piece.set_launch_direction(new_piece.center - enemy_global_pos)
			add_sibling(new_piece)
	await get_tree().process_frame
	enemy.perish()


func _on_tree_entered() -> void:
	if get_parent() is Path2D:
		set_path(get_parent())


func _on_area_entered(area : Area2D) -> void:
	if area is Enemy:
		cut_enemy(area)
