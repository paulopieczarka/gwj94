extends Machine

class_name MachineReactor

var charge := 100.0

func _ready() -> void:
	$InteractableComponent.interacted.connect(_on_interacted)

func _process(delta: float) -> void:
	charge = maxf(charge - 60.0 * delta, 0.0)
	
	if charge <= 0.0:
		mutate()
		charge = 100.0
	
	label.text = str(int(charge)) + "%"
	
func _on_interacted(actor: Node) -> void:
	print("Machine used by ", actor)
	charge += 10

func mutate() -> void:
	var start_cell: Vector2i = tile_map_layer.local_to_map(
		tile_map_layer.to_local(global_position)
	)
	var walls := get_unstable_cells(start_cell)
	if walls.size() == 0:
		return
	
	var index := randi_range(0, walls.size() - 1)
	var wall := walls[index]
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			var coors := wall + Vector2i(x, y)
			var sprite: Vector2i = tile_map_layer.get_cell_atlas_coords(coors)
			
			if sprite == Vector2i(1, 0):
				continue

			tile_map_layer.set_cell(
				coors,
				0,
				Vector2i(1, 0)
			)

			

	var pinks: Array[Vector2i] = tile_map_layer.get_used_cells_by_id(0, Vector2i(1, 0))
	for pink in pinks:
		var cells: Array[Vector2i] = tile_map_layer.get_surrounding_cells(pink)
		for cell in cells:
			if tile_map_layer.get_cell_source_id(cell) == -1:
				tile_map_layer.set_cell(
					cell,
					0,
					Vector2i(0, 0)
				)
			
func get_unstable_cells(start: Vector2i) -> Array[Vector2i]:
	const TARGET_TILE := Vector2i(0, 0)

	if tile_map_layer.get_cell_atlas_coords(start) != TARGET_TILE:
		return []

	var unstable_cells: Array[Vector2i] = []
	var stack: Array[Vector2i] = [start]
	var visited: Dictionary[Vector2i, bool] = {start: true}

	while not stack.is_empty():
		var cell: Array[Vector2i] = stack.pop_back()
		unstable_cells.append(cell)

		for neighbor in tile_map_layer.get_surrounding_cells(cell):
			if visited.has(neighbor):
				continue

			visited[neighbor] = true

			if tile_map_layer.get_cell_atlas_coords(neighbor) != TARGET_TILE:
				continue

			stack.append(neighbor)

	return unstable_cells
