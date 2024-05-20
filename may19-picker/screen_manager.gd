extends Node2D

func _ready():
	$mazeScreen.show()

func popup_message(message : String) -> void:
	$messageScreen.start_printing_message(message)
