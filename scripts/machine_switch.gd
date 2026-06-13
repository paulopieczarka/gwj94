extends Machine

class_name MachineSwitch

var is_on := true

func _process(delta: float) -> void:
	label.text = "ON" if is_on else "OFF"
	label.add_theme_color_override("font_color", Color.GREEN if is_on else Color.RED)

	if randf() < 0.01:
		is_on = false

func on_interacted(actor: Node) -> void:
	print("Machine 2 used by ", actor)
	is_on = !is_on
