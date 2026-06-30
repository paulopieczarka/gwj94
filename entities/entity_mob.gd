extends EntityCharacter

class_name EntityMob

@export var aggro_component: AggroComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(not aggro_component, "Missing aggro component")


func _process(delta: float) -> void:
	super._process(delta)
	
	facing_left = aggro_component.target.position.x < global_position.x
	velocity.move_toward(aggro_component.target.position, delta)
