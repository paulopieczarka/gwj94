extends Area2D

class_name InteractableComponent

signal interacted(actor: Node)

@onready var parent := get_parent()

func _ready() -> void:
	parent.add_to_group("interactable")
	
	collision_layer = 2
	collision_mask = 2
	
	var shape := CircleShape2D.new()
	shape.radius = 16

	var collision := CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)

func interact(actor: Node) -> void:
	interacted.emit(actor)
