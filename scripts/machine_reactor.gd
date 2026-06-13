extends Machine

class_name MachineReactor

var charge := 100.0

func _process(delta: float) -> void:
	charge = maxf(charge - 60.0 * delta, 0.0)
	
	if charge <= 0.0:
		mutate()
		charge = 100.0
	
	label.text = str(int(charge)) + "%"
	
func on_interacted(actor: Node) -> void:
	print("Machine used by ", actor)
	charge += 10

func mutate() -> void:
	var walls: Array[Vector2i] = tile_map_layer.get_used_cells_by_id(0, Vector2i(0, 0))
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
			
			var strange_body := StrangeBody.new()
			strange_body.global_position = tile_map_layer.to_global(
				tile_map_layer.map_to_local(coors)
			)
			get_parent().add_child(strange_body)
				
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
			
	
