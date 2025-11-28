@tool
class_name PathVisualizer
extends Line2D


enum LineType {
	FULL, HALF, QUARTER, EIGHTH
}


const HALF_DASHED_LINE = preload("uid://drgokd30pirq7")
const QUARTER_DASHED_LINE = preload("uid://dnlrmdls117j8")
const EIGHTH_DASHED_LINE = preload("uid://hlf7lfth82d6")


@export var path : Path2D:
	set = set_path
@export var line_type : LineType = LineType.FULL:
	set = set_line_type


func _init() -> void:
	set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	set_texture_mode(Line2D.LINE_TEXTURE_TILE)
	set_joint_mode(Line2D.LINE_JOINT_ROUND)
	set_begin_cap_mode(Line2D.LINE_CAP_ROUND)
	set_end_cap_mode(Line2D.LINE_CAP_ROUND)
	set_width(2.0)
	tree_entered.connect(_on_tree_entered)


func _physics_process(_delta : float) -> void:
	if not path:
		return
	var curve := path.get_curve()
	if not curve:
		clear_points()
		return
	
	points = curve.tessellate_even_length()


func set_path(value : Path2D) -> void:
	path = value
	if not path:
		points = []

func set_line_type(value : LineType) -> void:
	line_type = value
	match line_type:
		LineType.FULL:
			texture = null
		LineType.HALF:
			texture = HALF_DASHED_LINE
		LineType.QUARTER:
			texture = QUARTER_DASHED_LINE
		LineType.EIGHTH:
			texture = EIGHTH_DASHED_LINE

func _on_tree_entered() -> void:
	if get_parent() is Path2D:
		set_path(get_parent())
