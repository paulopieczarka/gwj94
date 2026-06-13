extends StaticBody2D

class_name StrangeBody

@onready var sprite := Sprite2D.new()
@onready var collision := CollisionShape2D.new()
@onready var interactable := InteractableComponent.new()

func _ready() -> void:
	sprite.name = "Sprite2D"
	sprite.texture = preload("res://assets/strange_body.png")
	add_child(sprite)

	var shape := RectangleShape2D.new()
	shape.size = Vector2(16, 16)

	collision.shape = shape
	add_child(collision)
	
	interactable.interacted.connect(on_interacted)
	add_child(interactable)
	
	play_pop_in_effect()

func on_interacted(actor: Node) -> void:
	print("Damaged used by ", actor)
func play_pop_in_effect() -> void:

	scale = Vector2.ZERO

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.25
	)
