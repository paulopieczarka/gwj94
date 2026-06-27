extends Area2D

class_name InteractableComponent

signal interacted(actor: Node)

var visual: CanvasItem
@onready var entity := get_owner()

func _ready() -> void:
	entity.add_to_group("interactable")
	

func interaction(actor: Node) -> void:
	play_interact_effect()
	interacted.emit(actor)

func play_interact_effect() -> void:
	var original_scale := scale

	var tween := create_tween()
	tween.tween_property(entity, "scale", original_scale * 1.05, 0.08)
	tween.tween_property(entity, "scale", original_scale, 0.08)
