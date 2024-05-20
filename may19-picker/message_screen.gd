extends Panel

var printing : bool = false

func _ready() -> void:
	Events.player_interacted_with_speaker.connect(start_printing_message)
	#$messageZone/advanceButton.shortcut.connect(func():
		#await get_tree().create_timer(0.1).timeout
		#$messageZone/advanceButton.button_up.emit()
	#)
	$messageZone/advanceButton.pressed.connect(func():
		if printing:
			$messageZone/messagePanel/Label.visible_ratio = 1.0
			printing = false
		else:
			if Input.is_key_pressed(KEY_SPACE): # was it shortcut-activated?
				await get_tree().create_timer(0.1).timeout
			hide()
			Events.message_screen_closed.emit()
	)

func start_printing_message(reader : Node2D, message : String):
	show()
	$messageZone.position.x = randi_range(5,35)
	$messageZone.position.y = randi_range(5,155)
	if reader.position.y < 100:
		$messageZone.position.y = randi_range(105,155)
	else:
		$messageZone.position.y = randi_range(5,95-41)
	$messageZone/messagePanel/Label.text = message
	$messageZone/messagePanel/Label.visible_characters = 0
	printing = true

func _physics_process(delta: float) -> void:
	if printing:
		$messageZone/messagePanel/Label.visible_characters += 1
		if $messageZone/messagePanel/Label.visible_ratio >= 1:
			printing = false # done
	#$messageZone/advanceButton.text = "v" if printing else "x" 
