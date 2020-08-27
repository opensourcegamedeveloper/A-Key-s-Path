extends TileSet
tool

export var cell_size: Vector2 = Vector2(16,16)

func _is_tile_bound(drawn_id, neighbor_id):
	# ground = 0
	# rock = 1
	# transition = 4
	# metal = 3
	var bound = false
	match drawn_id:
		0:
			match neighbor_id:
				1:
					bound = true
				4:
					bound = true
		3,4:
			match neighbor_id:
				3,4:
					bound = true
	return bound

func _create_collisions():
	# From a script by Boruok on Godot Forums
	# https://godotforums.org/discussion/22366/managing-tilemap-autotiling-and-collisions
	# Create the collisions for each tile at runtime
	for tile_id in get_tiles_ids():
		if tile_get_shape_count(tile_id) == 0:
			# The same shape will be shared for every part of this tile
			# For the terrain, use square collision shapes
			var shape = ConvexPolygonShape2D.new()
			shape.set_points([Vector2(0,0),Vector2(16,0),Vector2(16,16),Vector2(0,16)])
# warning-ignore:integer_division
			var columns = tile_get_texture(tile_id).get_width() / int(cell_size.x)
# warning-ignore:integer_division
			var rows = tile_get_texture(tile_id).get_height() / int(cell_size.y)
			for i in range(columns * rows):
				tile_add_shape(
					tile_id, shape,
					Transform2D(),
					false,
					Vector2(i % columns, i / columns))
				tile_set_shape(tile_id, tile_id, shape)