extends Node2D

@onready var path_visualizer: PathVisualizer = $Path2D/PathVisualizer
@onready var polygon_2d: Polygon2D = $Path2D/Polygon2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		#var clipped_polygons : Array[PackedVector2Array] = []
		var polyline : PackedVector2Array = path_visualizer.get_points()
		polyline = Transform2D(0, path_visualizer.get_global_position()) * polyline
		var polygon : PackedVector2Array = polygon_2d.get_polygon()
		polygon = Transform2D(0, polygon_2d.get_global_position()) * polygon
		var clipping_polygons := Geometry2D.offset_polyline(polyline, 2.0)
		for clipping_polygon : PackedVector2Array in clipping_polygons:
			var clipped_polygons := Geometry2D.clip_polygons(polygon, clipping_polygon)
			for clipped_polygon : PackedVector2Array in clipped_polygons:
				add_child(EnemyPiece.new(clipped_polygon))
		#for clipping_polygon : PackedVector2Array in clipping_polygons:
			#clipped_polygons.append_array(Geometry2D.clip_polygons(polygon, clipping_polygon))
		#spawn_polygons(clipped_polygons)

func spawn_polygons(clipped_polygons : Array[PackedVector2Array]) -> void:
	if clipped_polygons.size() <= 0:
		return
	for polygon : PackedVector2Array in clipped_polygons:
		add_child(EnemyPiece.new(polygon))
