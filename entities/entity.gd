extends CharacterBody2D

class_name Entity

@export var title: String = ""

@onready var sprite: Sprite2D = $Sprite2D

var facing_left := false

func _ready() -> void:
	assert(sprite != null, "[Entity] Missing sprite")

func _process(_delta: float) -> void:
	sprite.flip_h = facing_left
