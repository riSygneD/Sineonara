@abstract
class_name Enemy
extends Area2D

var speed : float = 48.0

func _init() -> void:
	set_monitoring(false)
	set_monitorable(true)
	set_collision_layer(1)
	set_collision_mask(0)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	global_position.x -= speed * delta


@abstract func get_polygon() -> PackedVector2Array


func get_global_polygon() -> PackedVector2Array:
	return Transform2D(0, get_global_position()) * get_polygon()


func perish() -> void:
	if Engine.is_editor_hint():
		return
	#set_collision_layer(0)
	#speed = 0
	#hide()
	#await get_tree().process_frame
	queue_free()
