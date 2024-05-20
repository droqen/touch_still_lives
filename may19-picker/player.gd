extends Node2D

signal used_door()
signal used_vending_machine()
signal used_tree()
signal used_go_outside()

@export var tap : TapPanel

enum { NOT_INTERACTING = 0, APPROACHING = 1, INTERACTION_AWAITING = 2, }

var interaction_state : int = NOT_INTERACTING
var interaction_mycell : Vector2i
var interaction_cell : Vector2i
var interaction_tid : int

var velocity : Vector2

func _ready():
	tap.tapped.connect(func(pos):
		$MazeGuide.goalcell = $MazeGuide.maze.local_to_map(pos)
		# move the goal a bit closer to the player for purposes of pathing to solid objects
		$MazeGuide.goal = $MazeGuide.goal + (position - $MazeGuide.goal).limit_length(1)
	)

func _physics_process(delta: float) -> void:
	var tonext = $MazeGuide.tonext
	if tonext:
		interaction_state = NOT_INTERACTING
		position.x += clampf(tonext.x,-1,1)
		position.y += clampf(tonext.y,-1,1)
		if tonext.x: $Sprite2D.flip_h = tonext.x < 0
	elif $MazeGuide.has_goal():
		interaction_state = NOT_INTERACTING
		var mycell : Vector2i = $MazeGuide.maze.local_to_map(position)
		var goalcell : Vector2i = $MazeGuide.goalcell
		if goalcell.distance_to(mycell) <= 1:
			var tid = $MazeGuide.maze.get_cell_tid(goalcell)
			match tid:
				2 , 4 , 6 , 8 , 16:
					interaction_state = APPROACHING
					interaction_mycell = mycell
					interaction_cell = goalcell
					interaction_tid = tid
		$MazeGuide.clear()
	elif interaction_state == APPROACHING:
		var halfway_point = (
			$MazeGuide.maze.map_to_local(interaction_mycell)
			+ $MazeGuide.maze.map_to_local(interaction_cell)
		) * 0.5
		var topoint = halfway_point - position
		if topoint:
			position.x += clampf(topoint.x,-1,1)
			position.y += clampf(topoint.y,-1,1)
			if topoint.x: $Sprite2D.flip_h = topoint.x < 0
		else:
			interact()

func interact():
	interaction_state = INTERACTION_AWAITING
	match interaction_tid:
		2:
			used_door.emit()
			#Events.player_interacted_with_speaker.emit(self, "A door. It's locked.")
			#interaction_state = INTERACTION_AWAITING
			#await Events.message_screen_closed
			#await Events.message_screen_closed
		4:
			used_vending_machine.emit()
			#await Events.message_screen_closed
		6, 8:
			used_tree.emit()
			#await Events.message_screen_closed
		16:
			used_go_outside.emit()
			#await Events.message_screen_closed
		_:
			pass
	interaction_state = NOT_INTERACTING
	$MazeGuide.goalcell = interaction_mycell
