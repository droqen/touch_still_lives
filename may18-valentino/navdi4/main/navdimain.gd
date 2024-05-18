@tool
extends Node2D
class_name NavdiMain

const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

@export var setup_button : bool :
	set(v) : if v :
		setting("application/config/name",
			"%d, %s %s ~ %s" %
				[time_year, time_month, stndth(time_day), game_name])
		setting("application/run/main_scene",
			scene_file_path)
		setting("display/window/size/viewport_width",
			maxi(1,game_size.x))
		setting("display/window/size/viewport_height",
			maxi(1,game_size.y))
		setting("display/window/size/window_width_override",
			maxi(1,game_size.x * view_scale.x))
		setting("display/window/size/window_height_override",
			maxi(1,game_size.y * view_scale.y))
		setting("display/window/stretch/mode",
			"viewport")
		setting("display/window/stretch/aspect",
			"ignore")
		setting("rendering/environment/defaults/default_clear_color",
			bg_colour)
		setting("application/boot_splash/bg_color",
			bg_colour)
		setting("application/boot_splash/image",
			icon.resource_path if icon else '')
		setting("application/config/icon",
			icon.resource_path if icon else '')
		setting("application/boot_splash/fullsize", false)
		if pixelated:
			setting("rendering/2d/snap/snap_2d_transforms_to_pixel", true)
			setting("rendering/2d/snap/snap_2d_vertices_to_pixel", true)
		
		notify_property_list_changed()
		ProjectSettings.notify_property_list_changed()
		ProjectSettings.save()
		
		print("changes to ProjectSettings saved!")

@export var game_name : String = "void"
@export var game_size : Vector2i = Vector2i(180, 200)
@export var view_scale : Vector2i = Vector2i(2, 2)
@export var icon : Texture2D
@export var bg_colour : Color = Color("#d45455")
@export var pixelated : bool = true
@export_category("Today's Date")
@export var autofill_today_button : bool :
	set(v):if v:
		var now = Time.get_datetime_dict_from_system()
		prints(now)
		time_year = now.year
		time_month = MONTHS[now.month-1]
		time_day = now.day
		notify_property_list_changed()
@export var time_year : int = 0
@export var time_month : String = "?"
@export var time_day : int = 0

func stndth(number : int) -> String:
	if number <= 0: return str(number)
	else: match number % 10:
		1: return str(number) + "st"
		2: return str(number) + "nd"
		_: return str(number) + "th"

func setting(name : String, value):
	ProjectSettings.set_setting(name, value)

func _ready() -> void:
	if texture_filter != TEXTURE_FILTER_NEAREST and pixelated:
		texture_filter = TEXTURE_FILTER_NEAREST
		notify_property_list_changed()
	if not Engine.is_editor_hint():
		var Cat = JavaScriptBridge.get_interface('Cat')
		if Cat:
			print("Cat found!")
			Cat.set_game_size(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
			)
		else:
			print("Cat not found - You do not have access to JS")
