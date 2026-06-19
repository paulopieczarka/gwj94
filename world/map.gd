extends TileMapLayer

@export var strange_body_scene: PackedScene

@onready var marker := $%Marker

func _process(delta: float) -> void:
	var cell_pos := local_to_map(get_local_mouse_position())
	highlight_cell(cell_pos, delta)
	
	if randf() < 0.02:
		mutate()

func highlight_cell(cell: Vector2i, delta: float) -> void:
	var target := map_to_local(cell)
	var weight := 1.0 - exp(-15.0 * delta)

	marker.position = marker.position.lerp(target, weight)

func mutate() -> void:
	var walls: Array[Vector2i] = get_used_cells_by_id(0, Vector2i(0, 0))
	var index := randi_range(0, walls.size() - 1)
	var wall := walls[index]
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			var coors := wall + Vector2i(x, y)
			var sprite: Vector2i = get_cell_atlas_coords(coors)
			
			if sprite == Vector2i(1, 0):
				continue

			set_cell(
				coors,
				0,
				Vector2i(1, 0)
			)
			
			assert(strange_body_scene != null, "Missing: strange body.")
			var strange_body := strange_body_scene.instantiate() as StrangeBody
			strange_body.global_position = to_global(map_to_local(coors))
			$%Entities.add_child(strange_body)
				
	var pinks: Array[Vector2i] = get_used_cells_by_id(0, Vector2i(1, 0))
	for pink in pinks:
		var cells: Array[Vector2i] = get_surrounding_cells(pink)
		for cell in cells:
			if get_cell_source_id(cell) == -1:
				set_cell(
					cell,
					0,
					Vector2i(0, 0)
				)
			
	
