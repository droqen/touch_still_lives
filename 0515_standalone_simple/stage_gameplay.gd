extends Node2D

enum { PLAYING, DEAD }

onready var plotst = TinyState.new(PLAYING,self,'mut_plot')
func mut_plot(_a,b):
	match b:
			PLAYING:
				$Label.show()
				$LabelDead.hide()
				if $Hunter.faceright:
					$MouseChaser.position = Vector2(12,88)
				else:
					$MouseChaser.position = Vector2(88,88)
				$MouseChaser.show()
			DEAD:
				$Label.hide()
				$LabelDead.show()
				$MouseChaser.hide()

var mous_held = false
func _physics_process(_delta):
	if plotst.id == PLAYING:
		if $Label.visible and $Hunter.aware:
			$Label.hide()
		if $Hunter.position.distance_to($MouseChaser.position) <3:
			plotst.goto(DEAD)
	if Input.is_mouse_button_pressed(1) != mous_held:
		mous_held = not mous_held
		var mous_pres = mous_held
		if mous_pres and plotst.id == DEAD:
			plotst.goto(PLAYING)
			$MouseChaser.position = get_global_mouse_position()
