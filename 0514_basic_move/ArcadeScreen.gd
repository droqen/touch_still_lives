tool
extends Node2D
class_name ArcadeScreen
export var size : Vector2 = Vector2(100, 100)

signal cursor_moved(newpos)
signal cursor_pressed(clickpos)
signal cursor_released(releasepos)
