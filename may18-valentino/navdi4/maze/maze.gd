@tool
extends TileMapLayer
class_name Maze

const SOLE_SOURCE_ID = 0
const SOLE_COLLISION_LAYER = 0
const SOLE_NAVIGATION_LAYER = 0

var tidkey_initialized : bool = false
var dict_tcoord_to_tid : Dictionary
var dict_tids_navigable : Dictionary
var tile_src : TileSetAtlasSource = null

func _ready():
	if not Engine.is_editor_hint(): _require_tidkey()

func _require_tidkey():
	if not tidkey_initialized:
		if tile_set==null:push_error("maze has no tileset");return false;
		tile_src = tile_set.get_source(SOLE_SOURCE_ID) as TileSetAtlasSource
		if tile_src==null:push_error("maze's tileset has no src");return false;
		dict_tcoord_to_tid.clear()
		dict_tids_navigable.clear()
		for tid in range(tile_src.get_tiles_count()):
			var tcoords = tile_src.get_tile_id(tid)
			dict_tcoord_to_tid[tcoords] = tid
			var tile_data : TileData = tile_src.get_tile_data(tcoords, 0)
			if tile_data.get_navigation_polygon(SOLE_NAVIGATION_LAYER):
				dict_tids_navigable[tid] = true
		tidkey_initialized = true # done!
		return true

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		navigation_enabled = false # no navigation.
		if tile_set and tile_set.get_source_count() > 0:
			tile_set.set_source_id(tile_set.get_source_id(0), SOLE_SOURCE_ID)

func set_cell_tid(maze_coords:Vector2i, tid:int):
	_require_tidkey()
	set_cell(maze_coords, SOLE_SOURCE_ID, tile_src.get_tile_id(tid))

func get_cell_tid(maze_coords:Vector2i) -> int:
	_require_tidkey()
	return dict_tcoord_to_tid.get(get_cell_atlas_coords(maze_coords),-1)

func is_cell_navigable(maze_coords:Vector2i) -> bool:
	_require_tidkey()
	return dict_tids_navigable.has(get_cell_tid(maze_coords))

func map_to_center(maze_coords:Vector2i) -> Vector2:
	return map_to_local(maze_coords) #+ (tile_set.tile_size as Vector2 * 0.5)
