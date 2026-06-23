extends Resource

class_name Race

@export var id: StringName
@export var display_name: String

@export var texture: Texture2D
@export var sprite_region: Vector2i

@export var max_health := 100
@export var speed := 80.0
@export var damage := 10
@export var attack_range := 32.0
