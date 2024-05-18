extends Node2D

const GROUNDFLOOR_Y_BOTTOM = 207
const FLOOR_HEIGHT = 40
const FLOOR_COUNT = 5
const ELEVATOR_RIGHT_X = 20
const GROUNDFLOOR_ELEVATOR_POS = Vector2(10, 185)
const GROUNDFLOOR_PLAYER_Y = 189

#const GROUNDFLOOR_CELL_Y = 18
#const FLOOR_HEIGHT_CELLS = 4

var target_none : bool = false
var m_released : bool = false
var target_floor : int = 0
var target_x : int = 0
var target_elevator : bool = false

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not m_released and target_none:
			pass # - if target_none, wait until mouse is released
		else:
			m_released = false
			var m = get_global_mouse_position()
			target_none = false
			target_floor = get_floor_from_pos(m)
			target_x = get_x_from_pos(m)
			if target_x <= ELEVATOR_RIGHT_X:
				target_elevator = true
			else:
				target_elevator = false
	else:
		m_released = true
	
	if target_none:
		$Label.text = "-"
		$ExamplePlayer.hide()
	elif target_elevator:
		$ExamplePlayer.show()
		$ExamplePlayer.position = Vector2(10, GROUNDFLOOR_PLAYER_Y - FLOOR_HEIGHT * target_floor)
		$Label.text = str($ExamplePlayer.position)
	else:
		$ExamplePlayer.show()
		$ExamplePlayer.position = Vector2(target_x, GROUNDFLOOR_PLAYER_Y - FLOOR_HEIGHT * target_floor)
		$Label.text = str($ExamplePlayer.position)

func get_x_from_pos(pos: Vector2)->float:
	if pos.x <= ELEVATOR_RIGHT_X:
		return 10
	else:
		return pos.x
func get_floor_from_pos(pos: Vector2)->int:
	return clampi(
		floori(
			(GROUNDFLOOR_Y_BOTTOM - pos.y) / FLOOR_HEIGHT
		),
		0,
		FLOOR_COUNT-1
	)

func get_elevatorpos_from_floor(floor: int)->Vector2:
	return GROUNDFLOOR_ELEVATOR_POS + Vector2.UP * (floor * FLOOR_HEIGHT)

#func get_cell_at_x_and_floor(x:float, floornumber:int)->Vector2i:
	#return Vector2i( floori(x/10), GROUNDFLOOR_CELL_Y - FLOOR_HEIGHT_CELLS * floornumber )
