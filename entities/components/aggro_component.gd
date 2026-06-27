extends Area2D

class_name AggroComponent

@export var target_group := "player"

var target: Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	print("dsds")
	if body.is_in_group(target_group):
		target = body

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null

func has_target() -> bool:
	return is_instance_valid(target)

func get_target_position() -> Vector2:
	return target.global_position
