extends Node

class_name WorldGenerator

enum Cell { WALL, FLOOR, SPAWN_POINT, RESOURCE, NPC_POINT, MOB_POINT }

func generate(width: int, height: int) -> Array[Array]:
	var grid := _init_grid(width, height)
	grid = _generate_noise(grid, 0.42)
	
	for i in range(5):
		grid = _apply_cellular_automata(grid)
		
		
	var best_spawn_region: Array[Vector2i] = []

	for region in _get_regions(grid, Cell.FLOOR):
		if region.size() > best_spawn_region.size():
			best_spawn_region = region
	
	var spawn_point: Vector2i = best_spawn_region.pick_random()
	grid[spawn_point.x][spawn_point.y] = Cell.SPAWN_POINT
	
	for i in range(200):
		var point: Vector2i = best_spawn_region.pick_random()
		grid[point.x][point.y] = Cell.MOB_POINT
	
	for region in _get_regions(grid, Cell.WALL):
		if region.size() < 50:
			for coord in region:
				grid[coord.x][coord.y] = Cell.FLOOR
		else: if region.size() < 200:
			for coord in region:
				grid[coord.x][coord.y] = Cell.RESOURCE
				
	var visited: Array[Array] = []
	visited.resize(grid.size())
	
	for y in grid.size():
		var row: Array[bool] = []
		row.resize(grid[y].size())

		for x in grid[y].size():
			row[x] = false

		visited[y] = row
				
	
	var spawn_region := _get_region_tiles(grid, spawn_point, Cell.FLOOR, visited)
	
	var npc_count := 0
	while npc_count < 4:
		var npc_spawn_point: Vector2i = spawn_region.pick_random()
		var dist := spawn_point.distance_to(npc_spawn_point)

		if dist < 40:
			grid[npc_spawn_point.y][npc_spawn_point.x] = Cell.NPC_POINT
			npc_count += 1
				
	return grid
	
func _init_grid(width: int, height: int) -> Array[Array]:
	var new_grid: Array[Array] = []
	new_grid.resize(height)

	for y in height:
		var row: Array = []
		row.resize(width)

		for x in width:
			row[x] = Cell.WALL

		new_grid[y] = row

	return new_grid
	
func _generate_noise(grid: Array[Array], floor_ratio: float) -> Array[Array]:
	for y in grid.size():
		for x in grid[y].size():
			if randf() < floor_ratio:
				grid[y][x] = Cell.FLOOR
			else:
				grid[y][x] = Cell.WALL
				
	return grid
	
func _apply_cellular_automata(grid: Array[Array]) -> Array[Array]:
	var previous_grid := grid.duplicate(true)

	for y in grid.size():
		for x in grid[y].size():
			var neighbor_wall_count := 0

			for j in range(y - 1, y + 2):
				for i in range(x - 1, x + 2):
					if i == x and j == y:
						continue

					if j >= 0 and j < previous_grid.size() and i >= 0 and i < previous_grid[j].size():
						if previous_grid[j][i] == Cell.WALL:
							neighbor_wall_count += 1
					else:
						neighbor_wall_count += 1

			if neighbor_wall_count > 4:
				grid[y][x] = Cell.WALL
			else:
				grid[y][x] = Cell.FLOOR

	return grid
	
func _get_regions(grid: Array[Array], target_cell: Cell) -> Array[Array]:
	var regions: Array[Array] = []
	var visited: Array[Array] = []
	visited.resize(grid.size())
	
	for y in grid.size():
		var row: Array[bool] = []
		row.resize(grid[y].size())

		for x in grid[y].size():
			row[x] = false

		visited[y] = row

	for y in grid.size():
		for x in grid[y].size():
			if visited[y][x]:
				continue

			if grid[y][x] != target_cell:
				continue

			var region := _get_region_tiles(grid, Vector2i(x, y), target_cell, visited)
			regions.append(region)

	return regions

func _get_region_tiles(
	grid: Array[Array],
	start: Vector2i,
	target_cell: Cell,
	visited: Array[Array]
) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	var queue: Array[Vector2i] = [start]

	visited[start.y][start.x] = true

	while queue.size() > 0:
		var current: Vector2i = queue.pop_front()
		tiles.append(current)

		var neighbors: Array[Vector2i] = [
			current + Vector2i.UP,
			current + Vector2i.DOWN,
			current + Vector2i.LEFT,
			current + Vector2i.RIGHT,
		]

		for neighbor in neighbors:
			if not _is_inside_grid(grid, neighbor):
				continue

			if visited[neighbor.y][neighbor.x]:
				continue

			if grid[neighbor.y][neighbor.x] != target_cell:
				continue

			visited[neighbor.y][neighbor.x] = true
			queue.append(neighbor)

	return tiles
	
func _is_inside_grid(grid: Array[Array], pos: Vector2i) -> bool:
	return (
		pos.y >= 0
		and pos.y < grid.size()
		and pos.x >= 0
		and pos.x < grid[pos.y].size()
	)
