extends StaticBody2D

class_name StrangeBody

func _ready() -> void:
	play_pop_in_effect()

	$InteractableComponent.interacted.connect(_on_interacted)

func _on_interacted(actor: Node) -> void:
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
