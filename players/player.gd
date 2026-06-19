extends CharacterBody2D

class_name Player

const max_speed := 100
const acceleration := 50
const friction := 8

@onready var sprite: Sprite2D = $Sprite2D
@onready var upper_limbs: Node2D = $UpperLimbs
@onready var left_arm: Node2D = $UpperLimbs/LeftArm
@onready var right_arm: Node2D = $UpperLimbs/RightArm
@onready var left_arm_sprite: Sprite2D = $UpperLimbs/LeftArm/Sprite2D
@onready var right_arm_sprite: Sprite2D = $UpperLimbs/RightArm/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

var left_arm_tween: Tween
var right_arm_tween: Tween
var is_holding_ranged_weapon := false
var facing_left := false

func _ready() -> void:
	add_to_group("player")
	
	animated_sprite.z_index = 1
	left_arm_sprite.z_index = 0
	right_arm_sprite.z_index = 2
	
	$InteractableComponent.interacted.connect(_on_interacted)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("slot_1"):
		is_holding_ranged_weapon = !is_holding_ranged_weapon

	if Input.is_action_just_pressed("interact"):
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collision_mask = 2
		query.collide_with_areas = true
		query.collide_with_bodies = false

		for hit in get_world_2d().direct_space_state.intersect_point(query):
			var area := hit.collider as InteractableComponent

			if area:
				area.interaction(self)
				return

func _physics_process(delta: float) -> void:
	var input: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	).normalized()
	
	if is_holding_ranged_weapon and not animation_player.is_playing():
		animation_player.play(
			"hold_ranged_weapon_" + ("left" if facing_left else "right"),
			0.08
		)
	
	if input.length() > 0.1:
		animated_sprite.play("walking")
		if not animation_player.is_playing():
			animation_player.play("walking", 0.08)
	else:
		animated_sprite.stop()
		if not is_holding_ranged_weapon:
			animation_player.play("RESET", 0.08)
		
	if input.x != 0:
		animation_tree.set("parameters/Idle/blend_position", input.x)
		#var is_left := input.x < 0
		
	
	var lerp_weight := delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * max_speed, lerp_weight)

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
