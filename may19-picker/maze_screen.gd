extends Node2D

var maze_index : int = 1
const MAZE1 = preload("res://maze1.tscn")
const MAZE2 = preload("res://maze2.tscn")
const MAZE1_BLOCKED = preload("res://maze1_blocked.tscn")
const MAZE2_BLOCKED = preload("res://maze2_blocked.tscn")

var doors_times_used : int = 0
var tried_bad_drink : bool = false
var trees_examined : int = 0
var got_drink : bool = false

func _ready():
	randomize()
	Events.player_interacted_with_speaker.emit.call_deferred($player, "Oh, man, it's hot outside! I came in here for some shade, but I think I see a vending machine... I am kinda thirsty.")
	$player.used_door.connect(func():
		if tried_bad_drink:
			match doors_times_used:
				0:
					if got_drink:
						Events.player_interacted_with_speaker.emit($player,
							"I stepped through the door and suddenly a verdant tree sprouted up in front of me. Strange.")
					else:
						Events.player_interacted_with_speaker.emit($player,
							"I stepped through the door and wondered if I might find a better vending machine down here...")
					#await Events.message_screen_closed
				_:
					pass
			doors_times_used += 1
			$player/Sprite2D.flip_h = not $player/Sprite2D.flip_h
			maze_index = 2 if (maze_index == 1) else 1
			if got_drink:
				goto_maze([null,MAZE1_BLOCKED,MAZE2_BLOCKED]
					[maze_index].instantiate())
			else:
				goto_maze([null,MAZE1,MAZE2]
					[maze_index].instantiate())
		else:
			Events.player_interacted_with_speaker.emit($player,
				"I don't need to go through this door, there's a vending machine right there at the end of that hallway.")
	)
	$player.used_vending_machine.connect(func():
		match [got_drink,maze_index]:
			[true,_]:
				Events.player_interacted_with_speaker.emit($player,
				"A vending machine. I don't need anything else to drink, I'm good.")
			[_,1]:
				Events.player_interacted_with_speaker.emit($player,
				"A vending machine. But... it doesn't have golden grape. Is it really worth drinking if it's not golden grape? (No.)")
				tried_bad_drink = true
			[_,2]:
				Events.player_interacted_with_speaker.emit($player,
				"A vending machine. Ah, this one has golden grape!")
				await Events.message_screen_closed
				Events.player_interacted_with_speaker.emit($player,
				"*Clunk*\nI love how it comes with its own straw.")
				await Events.message_screen_closed
				Events.player_interacted_with_speaker.emit($player,
				"\n*Sluuurp*\nRefreshing! Okay, let's get out of here.")
				got_drink = true
				doors_times_used = 0
	)
	$player.used_tree.connect(func():
		if maze_index == 2:
			Events.player_interacted_with_speaker.emit(self, "The roots of the tree above, burst from the floor above to this one below... How deep do they go?")
		else:
			if trees_examined == 0:
				Events.player_interacted_with_speaker.emit(self, "The beauty of nature, erupted through cold concrete and tile. Going to cost someone a lot to fix that.")
			else:
				Events.player_interacted_with_speaker.emit(self, "The beauty of nature, erupted through cold concrete and tile.")
			trees_examined += 1
	)
	$player.used_go_outside.connect(func():
		if got_drink:
			Events.player_interacted_with_speaker.emit(self, "Great. Let's get out of here.")
			await Events.message_screen_closed
			Events.player_interacted_with_speaker.emit(self, "Well, goodbye, little indoor forest.")
			await Events.message_screen_closed
			Events.player_interacted_with_speaker.emit(self, "...")
			await Events.message_screen_closed
			Events.player_interacted_with_speaker.emit(self, "*Sluuuurp*")
			await Events.message_screen_closed
			hide(); set_process(false);
		else:
			Events.player_interacted_with_speaker.emit(self, "A way out. But, I'm still thirsty.")
	)

func goto_maze(new_maze : Maze):
	var current_maze : Maze = $mazeContainer.get_child(0)
	$mazeContainer.remove_child(current_maze)
	new_maze.tree_entered.connect(func():$MazeBake._bake(), CONNECT_ONE_SHOT)
	$mazeContainer.add_child(new_maze)
