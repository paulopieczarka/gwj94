extends StaticBody2D

class_name Machine2

@onready var _label := Label.new()
@onready var _interactable := InteractableComponent.new()

var is_on := true

func _ready() -> void:
	_interactable.interacted.connect(_on_interacted)
	add_child(_interactable)
	
	_label.text = "ON" if is_on else "OFF"
	_label.position = Vector2(-7, -9)
	_label.add_theme_color_override("font_color", Color.WHITE)
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 4)
	_label.add_theme_font_size_override("font_size", 8)
	add_child(_label)
	
func _process(delta: float) -> void:
	_label.text = "ON" if is_on else "OFF"
	_label.add_theme_color_override("font_color", Color.GREEN if is_on else Color.RED)

	if randf() < 0.01:
		is_on = false

func _on_interacted(actor: Node) -> void:
	print("Machine 2 used by ", actor)
	is_on = !is_on
