extends Node

@export var max: float = 100.0
@export var value = max

func _ready() -> void:
	add_to_group("damageable")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
