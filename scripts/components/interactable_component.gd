extends Area2D

class_name InteractableComponent

signal interacted(actor: Node)

var visual: CanvasItem
var _default_material: Material
var _highlight_material: ShaderMaterial

@onready var parent := get_parent()
@onready var shape: Shape2D
@onready var collision := CollisionShape2D.new()

func _ready() -> void:
	parent.add_to_group("interactable")
	visual = parent.get_node_or_null("Sprite2D") as CanvasItem
	
	collision_layer = 2
	collision_mask = 2
	
	if shape == null:
		shape = RectangleShape2D.new()
		shape.size = Vector2i(16, 16)
	
	collision.shape = shape
	add_child(collision)
	
	_highlight_material = ShaderMaterial.new()
	_highlight_material.shader = preload("res://shaders/highlight.gdshader")

	if visual:
		_default_material = visual.material

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func interact(actor: Node) -> void:
	interacted.emit(actor)
	play_interact_effect()

func play_interact_effect() -> void:
	var original_scale := scale

	var tween := create_tween()
	tween.tween_property(parent, "scale", original_scale * 1.05, 0.08)
	tween.tween_property(parent, "scale", original_scale, 0.08)

func _on_mouse_entered() -> void:
	if visual:
		visual.material = _highlight_material

func _on_mouse_exited() -> void:
	if visual:
		visual.material = _default_material
