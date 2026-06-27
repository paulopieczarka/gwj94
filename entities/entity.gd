extends CharacterBody2D

class_name Entity

@export var title: String = ""

@onready var sprite := $Sprite2D

var facing_left := false

func _process(_delta: float) -> void:
	scale.x = -1.0 if facing_left else 1.0
