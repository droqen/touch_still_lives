extends Node2D

var at_door : bool = false
var at_door_duration : int = 0
var at_door_cell : Vector2i

func _ready():
	$pin.target_floor = $pin.get_floor_from_pos($player.position)
	$pin.target_x = $pin.get_x_from_pos($player.position)
	$floor_3_label.hide()

func _physics_process(delta: float) -> void:
	
	var ptargetx = $pin.target_x
	var pfloor = $pin.get_floor_from_pos($player.position)
	
	if pfloor == 3 and at_door:
		$floor_3_label.show()
		ptargetx = $player.position.x # nope.
		if at_door_duration > 240:
			pfloor = -1
			if $elevator.position.y > 200:
				$ending_label.show()
	elif pfloor != $pin.target_floor:
		if $player.position.x <= 10 or ptargetx <= 10:
			ptargetx = 10
		else:
			ptargetx = $player.position.x # nope.
	elif $elevator/closed.visible and ptargetx < 25 and $player.position.x > 15:
		ptargetx = 25
	elif $player.position.x <= 10 and $elevator/closed.visible:
		ptargetx = 10
	if ptargetx > 175: ptargetx = 175
	var x2 = move_toward($player.position.x, ptargetx, 1.0)
	$player.xvel = x2-$player.position.x
	$player.position.x=x2
	
	if $player.xvel == 0:
		var playercell = $TileMapLayer.local_to_map($player.position + Vector2.UP)
		match $TileMapLayer.get_cell_atlas_coords(playercell):
			Vector2i(3,1), Vector2i(3,2):
				at_door_duration += 1
				at_door_cell = playercell
			_:
				at_door_duration = 0
	else:
		at_door_duration = 0
	
	if at_door_duration == 11:
		at_door = true
		if $TileMapLayer.get_cell_atlas_coords(at_door_cell) == Vector2i(3,1):
			$player.hide()
			$TileMapLayer.set_cell(at_door_cell, 0, Vector2i(3,2)) # open door
	elif at_door and at_door_duration <= 0:
		at_door = false
		$player.show()
		#$TileMapLayer.set_cell(at_door_cell, 0, Vector2i(3,1)) # shut door
		
	for i in range(5):
		if i == pfloor and ($player.position.x > 10 or not $elevator/closed.visible):
			if pfloor == 3 and $floor_3_label.visible and at_door_duration > 240:
				$floorhiders.get_child(i).show()
			else:
				$floorhiders.get_child(i).hide()
		else:
			$floorhiders.get_child(i).show()

	var elevator_target_floor = pfloor

	if $player.position.x <= 10:
		$player.position.y = $elevator.position.y + 4
		elevator_target_floor = $pin.target_floor
	
	var elevatorpos2 = $pin.get_elevatorpos_from_floor(elevator_target_floor)
	var elevator_totarget = elevatorpos2 - $elevator.position
	if elevator_totarget:
		$elevator/closed.show()
		$elevator.position += elevator_totarget.limit_length(1.0)
		if $player.position.x <= 10:
			$player.xvel = 1 # just face right
	else:
		$elevator/closed.hide()
