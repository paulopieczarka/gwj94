extends EntityCharacter

class_name EntityPlayer

func _ready() -> void:
	super._ready()
	
	add_to_group("player")
	
func _process(delta: float) -> void:
	super._process(delta)
	
	var mouse_pos := get_global_mouse_position()
	facing_left = mouse_pos.x < global_position.x
	front_hand.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("interact"):
		_attack()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var input: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	).normalized()
	
	is_walking = input != Vector2.ZERO
	
	var lerp_weight := delta * (acceleration if input else friction)
	movement_velocity = lerp(velocity, input * max_speed, lerp_weight)
