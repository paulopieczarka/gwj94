extends Button

@onready var sprite: Sprite2D = $%Sprite2D

const FRAME_SIZE := Vector2i(16, 16)
const FRAME_COUNT := 4

var index := 0

func _on_pressed() -> void:
	index += 1
	
	if index >= 16:
		index = 0
	
	var x := index % FRAME_COUNT
	var y := int(index / FRAME_COUNT)
	
	sprite.region_rect = Rect2(
		x * 16,
		y * 16,
		16,
		16
	)
	
