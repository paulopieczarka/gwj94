extends Entity

class_name Player

const max_speed := 100
const acceleration := 50
const friction := 8

@onready var front_hand: Node2D = $Hand/Front
@onready var weapon_sprite: Sprite2D = $Hand/Front/Node2D/Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

var locomotion: AnimationNodeStateMachinePlayback

func _ready() -> void:
	add_to_group("player")
	
	sprite.z_index = 1
	
	$InteractableComponent.interacted.connect(_on_interacted)
	
	if $CombatComponent.weapon != null:
		weapon_sprite.texture = $CombatComponent.weapon.sprite
	
	animation_tree.active = true
	locomotion = animation_tree.get("parameters/StateMachine/playback")
	
func _process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var is_left := mouse_pos.x < global_position.x

	sprite.flip_h = is_left
	
	front_hand.look_at(mouse_pos)
	front_hand.scale.y = -1 if is_left else 1
	
	$CombatComponent.scale.x = -1 if is_left else 1

	if Input.is_action_just_pressed("slot_1"):
		pass
		#is_holding_ranged_weapon = !is_holding_ranged_weapon

	if Input.is_action_just_pressed("interact"):
		if !animation_tree.get("parameters/OneShot/active"):
			animation_tree.set(
				"parameters/OneShot/request",
				AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			)
				
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collision_mask = 2
		query.collide_with_areas = true
		query.collide_with_bodies = false

		for hit in get_world_2d().direct_space_state.intersect_point(query):
			var area := hit.collider as InteractableComponent

			if area:
				
				sfx.play()
				area.interaction(self)
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
	
	if input != Vector2.ZERO:
		locomotion.travel("walking")
	else:
		locomotion.travel("idle")

	move_and_slide()

func _on_interacted(node: Node2D) -> void:
	show_speech("Hi! I'm Billy")

func show_speech(text: String) -> void:
	var bubble := Label.new()
	bubble.text = text
	bubble.position = Vector2(-20, -40)
	bubble.z_index = 10
	get_parent().add_child(bubble)

	var tween := create_tween()
	tween.tween_interval(1.5)
	tween.tween_property(bubble, "modulate:a", 0.0, 0.3)
	tween.tween_callback(bubble.queue_free)
