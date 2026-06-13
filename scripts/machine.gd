extends StaticBody2D

class_name Machine

@onready var _label := Label.new()
@onready var _interactable := InteractableComponent.new()
@onready var _tile_map_layer := $%TileMapLayer

var charge := 100.0

func _ready() -> void:
	_interactable.interacted.connect(_on_interacted)
	add_child(_interactable)
	
	_label.text = "100%"
	_label.position = Vector2(-7, -9)
	_label.add_theme_color_override("font_color", Color.WHITE)
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 4)
	_label.add_theme_font_size_override("font_size", 8)
	add_child(_label)
	
func _process(delta: float) -> void:
	charge = maxf(charge - 20.0 * delta, 0.0)
	
	if charge <= 0.0:
		_mutate()
		charge = 100.0
	
	_label.text = str(int(charge)) + "%"

func _on_interacted(actor: Node) -> void:
	print("Machine used by ", actor)
	charge += 10

func _mutate() -> void:
	var center: Vector2i = _tile_map_layer.local_to_map(
		_tile_map_layer.to_local(global_position)
	)
	
	center += Vector2i(randi_range(-16, 16), randi_range(-16, 16))
	
	for i in 8:
		for j in 8:
			_tile_map_layer.set_cell(
				center + Vector2i(i, j),
				0,
				Vector2i(1, 0)
			)
