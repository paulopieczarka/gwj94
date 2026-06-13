extends TileMapLayer

@onready var marker := $%Marker

func _process(delta: float) -> void:
	var cell_pos := local_to_map(get_local_mouse_position())
	highlight_cell(cell_pos, delta)

func highlight_cell(cell: Vector2i, delta: float) -> void:
	var target := map_to_local(cell)
	var weight := 1.0 - exp(-15.0 * delta)

	marker.position = marker.position.lerp(target, weight)
