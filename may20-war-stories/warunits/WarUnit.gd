extends Node2D
class_name WarUnit

@export var stats : WarUnitStats

var team : int :
	get() : return stats.team

# range is always the same
const COLLISION_RADIUS : float = 4.0 * 2
const ATTACK_RADIUS : float = 6.5 * 2
const AGGRO_RADIUS : float = 40.0
const SHARED_AGGRO_RADIUS : float = 40.0
const COLLISION_RADIUS_SQR : float = COLLISION_RADIUS * COLLISION_RADIUS
const ATTACK_RADIUS_SQR : float = ATTACK_RADIUS * ATTACK_RADIUS
const AGGRO_RADIUS_SQR : float = AGGRO_RADIUS * AGGRO_RADIUS
const SHARED_AGGRO_RADIUS_SQR : float = SHARED_AGGRO_RADIUS * SHARED_AGGRO_RADIUS

const TEAM_0_COLOUR : Color = Color("#d5aa59")
const TEAM_1_COLOUR : Color = Color("#efc8e2")

@onready var hp = stats.hp_max
var knockback_frames : int = 0
var knockback_dir : Vector2i

var _attack_buf : int = 0
var _move_buf : int = 0
var _anim_buf : int = 0
var _show_hp_buf : int = 0

var chasing : bool = false
var chasing_unit : WarUnit = null
var final_goalcell : Vector2i

func _ready():
	$MazeGuide.maze_bake = $"../../MazeBake" # hmm
	print(team)
	$Sprite/maxbar/hpbar/c.color = [TEAM_0_COLOUR,TEAM_1_COLOUR][team]

func _physics_process(delta: float) -> void:
	
	var previous_frame_position = position
	
	if _show_hp_buf > 0:
		_show_hp_buf -= 1
		$Sprite/maxbar.show()
		if hp >= stats.hp_max:
			$Sprite/maxbar/hpbar.scale.x = 1.0
		elif hp <= 0:
			$Sprite/maxbar/hpbar.scale.x = 0.0
		else:
			$Sprite/maxbar.show()
			$Sprite/maxbar/hpbar.scale.x = clampf(hp*1.0/stats.hp_max, 0.1, 0.9)
	else:
		$Sprite/maxbar.hide()
	
	if knockback_frames > 0:
		knockback_frames -= 1
		position += knockback_dir as Vector2
	
	if _attack_buf > 0:
		_attack_buf -= 1
	else:
		if _move_buf > 0:
			_move_buf -= 1
		else:
			var tonext = $MazeGuide.tonext
			position += Vector2(
				clampf(tonext.x,-1,1),
				clampf(tonext.y,-1,1),
			)
			_move_buf = floori(stats.move_reload+randf())
		if _anim_buf > 0:
			_anim_buf -= 1
		else:
			var tonext = $MazeGuide.tonext
			if tonext:
				$Sprite/Sprite2D.frame = stats.first_frame + (
					2 if ($Sprite/Sprite2D.frame==stats.first_frame+1) else 1)
				_anim_buf = stats.anim_period
			else:
				$Sprite/Sprite2D.frame = stats.first_frame
				# i have arrived at my destination
				if final_goalcell:
					$MazeGuide.goalcell = final_goalcell
	
	if chasing:
		if is_instance_valid(chasing_unit):
			$MazeGuide.goal = chasing_unit.position
		else:
			chasing = false
			$MazeGuide.clear()
	
	$Sprite.position *= 0.5
	$Sprite.position += previous_frame_position - position

func proc_proximity(other_unit : WarUnit):
	var to_other = other_unit.position - position
	var dist_sqr = to_other.length_squared()
	if not chasing and other_unit.chasing and team == other_unit.team:
		if dist_sqr < SHARED_AGGRO_RADIUS_SQR:
			chase(other_unit.chasing_unit)
	if team != other_unit.team:
		if dist_sqr < AGGRO_RADIUS_SQR:
			chase(other_unit)
		if dist_sqr < ATTACK_RADIUS_SQR:
			attack(other_unit)
	if dist_sqr < COLLISION_RADIUS_SQR:
		# push in a circle.
		position -= to_other.normalized().rotated(PI*0.20)
		#position.x -= sign(to_other.y if to_other.y else randi_range(-1,1))
		#position.y += sign(to_other.x if to_other.x else randi_range(-1,1))
		#_move_buf = 5 # mild stun if i bump into someone

func attack(other_unit : WarUnit):
	if _attack_buf > 0: return # nope
	var damage = maxi(1, self.stats.attack_pwr - other_unit.stats.armour)
	other_unit.takedamage(damage)
	#if damage<3:
		#other_unit.knockback_frames = 1
	#elif damage<10:
		#other_unit.knockback_frames = 2
	#else:
		#other_unit.knockback_frames = 3
	#other_unit.knockback_dir = Vector2(
		#sign(other_unit.position.x-position.x),
		#sign(other_unit.position.y-position.y))
	#other_unit.hp -= damage
	#if other_unit.hp <= 0: other_unit.queue_free()
	_attack_buf = stats.attack_reload + randi()%3

func chase(other_unit : WarUnit):
	if not chasing:
		chasing = true
		chasing_unit = other_unit

func takedamage(damage : int):
	hp -= damage
	_show_hp_buf = 60
	if hp <= 0: queue_free()
