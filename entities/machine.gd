extends StaticBody2D

class_name Machine

@onready var tile_map_layer := $%TileMapLayer

@onready var label := Label.new()

func _ready() -> void:
	var shape = RectangleShape2D.new()
	shape.size = Vector2i(32, 32)
	
	label.text = "100%"
	label.position = Vector2(-7, -9)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_size_override("font_size", 8)
	add_child(label)
	
