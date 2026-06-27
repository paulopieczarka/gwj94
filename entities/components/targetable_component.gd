extends Area2D

class_name TargetableComponent

@export var outline_material: ShaderMaterial

@onready var entity := get_owner()
@onready var sprite := entity.get_node_or_null("Sprite2D") as CanvasItem

var is_selected := false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	is_selected = true

	if sprite:
		sprite.material = outline_material

func _on_mouse_exited() -> void:
	is_selected = false

	if sprite:
		sprite.material = null
