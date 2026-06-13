extends CharacterBody2D

class_name Player

var speed := 100.0

@onready var _interactable := InteractableComponent.new()

func _ready() -> void:
	add_to_group("player")
	
	add_child(_interactable)

func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("interact"):
		return

	for area in _interactable.get_overlapping_areas():
		if area is InteractableComponent:
			area.interact(self)
			return

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	) * speed

	move_and_collide(velocity * delta)
