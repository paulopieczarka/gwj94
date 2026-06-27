extends Area2D

class_name InteractableComponent

@export var highlight_material: ShaderMaterial

signal interacted(actor: Node)

var visual: CanvasItem
@onready var entity := get_owner()
@onready var sprite := entity.get_node_or_null("Sprite2D") as CanvasItem

func _ready() -> void:
	entity.add_to_group("interactable")
	
	collision_layer = 2
	collision_mask = 0
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func interaction(actor: Node) -> void:
	play_interact_effect()
	interacted.emit(actor)

func play_interact_effect() -> void:
	var original_scale := scale

	var tween := create_tween()
	tween.tween_property(entity, "scale", original_scale * 1.05, 0.08)
	tween.tween_property(entity, "scale", original_scale, 0.08)

func _on_mouse_entered() -> void:
	if sprite:
		sprite.material = highlight_material

func _on_mouse_exited() -> void:
	if sprite:
		sprite.material = null
