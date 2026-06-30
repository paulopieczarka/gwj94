extends ProgressBar

class_name HealthComponent

@onready var entity := owner

signal damaged(other: Entity, damage: int)

func _ready() -> void:
	add_to_group("damageable")
	
	value = max_value

func damage(other: Entity, damage: int) -> void:
	value -= damage
	damaged.emit(other, damage)
	
	if (value <= 0.0):
		entity.queue_free()
