extends CharacterBody2D

class_name Player

const max_speed := 100
const acceleration := 50
const friction := 8

@onready var interactable := InteractableComponent.new()

func _ready() -> void:
	add_to_group("player")
	
	var shape = CircleShape2D.new()
	shape.radius = 16
	
	interactable.shape = shape
	add_child(interactable)

func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("interact"):
		return

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collision_mask = 2
	query.collide_with_areas = true
	query.collide_with_bodies = false

	for hit in get_world_2d().direct_space_state.intersect_point(query):
		var area := hit.collider as InteractableComponent

		if area:
			area.interact(self)
			return

func _physics_process(delta: float) -> void:
	var input: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	).normalized()
	
	var lerp_weight := delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * max_speed, lerp_weight)

	move_and_slide()
