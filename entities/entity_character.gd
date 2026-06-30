extends Entity

class_name EntityCharacter

const max_speed := 100
const acceleration := 50
const friction := 8

@onready var front_hand: Node2D = $Hand/Front
@onready var weapon_sprite: Sprite2D = $Hand/Front/Node2D/Sprite2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var interactable: InteractableComponent = $InteractableComponent
@onready var combat: CombatComponent = $CombatComponent
@onready var health: HealthComponent = $HealthComponent

@onready var animation_tree: AnimationTree = $AnimationTree

var is_walking := false
var locomotion: AnimationNodeStateMachinePlayback

var knockback_velocity := Vector2.ZERO
var movement_velocity := Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	sprite.z_index = 1

	assert(animation_tree != null, "[EntityCharacter] Missing animation_tree")

	assert(combat != null, "[EntityCharacter] Missing combat")
	combat.connect("hit", _on_hit)
	health.connect("damaged", _on_damaged)
	
	_change_weapon()
	
	animation_tree.active = true
	
	locomotion = animation_tree.get("parameters/StateMachine/playback")
	assert(locomotion != null, "[EntityCharacter] Missing locomotion")
	
func _process(delta: float) -> void:
	super._process(delta)

	_update_facing_direction()
	_update_animation()
	
	move_and_slide()
	

func _physics_process(delta: float) -> void:
	if knockback_velocity.length() <= 8.0:
		knockback_velocity = Vector2.ZERO
	else:
		knockback_velocity = knockback_velocity.lerp(
			Vector2.ZERO,
			1.0 - exp(-12.0 * delta)
		)

	velocity = movement_velocity + knockback_velocity

func _update_animation() -> void:
	if is_walking:
		locomotion.travel("walking")
	else:
		locomotion.travel("idle")

func _update_facing_direction() -> void:
	front_hand.scale.y = -1 if facing_left else 1
	combat.scale.x = -1 if facing_left else 1

func _on_hit(target: Entity, damage: int) -> void:
	var knockback_dir := (target.global_position - global_position).normalized()
	target.knockback_velocity = knockback_dir * 100.0
	
func _on_damaged(target: Entity, damage: int) -> void:
	print(target.title, ' -> ', title)
	velocity += Vector2(10.0, 20.0)

func _attack() -> void:
	combat.attack()
	animation_tree.set(
		"parameters/OneShot/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	
func _change_weapon() -> void:
	if combat.weapon == null:
		weapon_sprite.texture = null
		return
	
	weapon_sprite.texture = combat.weapon.sprite
