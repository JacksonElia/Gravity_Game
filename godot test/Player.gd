extends KinematicBody2D

const MOVE_SPEED = 500
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velo = 0
var x_velo = 0
var facing_right = false
var gravity_dir = [1, 0]

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if gravity_dir[0] == 0:
		x_velo = move_dir * MOVE_SPEED
	elif gravity_dir[1] == 0:
		y_velo = move_dir * MOVE_SPEED
	
	var grounded = is_on_floor()
	y_velo += gravity_dir[1] * GRAVITY
	x_velo += gravity_dir[0] * GRAVITY
	if grounded and Input.is_action_just_pressed("jump"):
		if gravity_dir[0] == 0:
			y_velo = -JUMP_FORCE * gravity_dir[1]
		elif gravity_dir[1] == 0:
			x_velo = JUMP_FORCE * gravity_dir[0]
	if grounded and y_velo >= 0:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
	
	move_and_slide(Vector2(x_velo, y_velo), Vector2(0, -1))
	
	if facing_right and move_dir < 0:
		flip()
	if !facing_right and move_dir > 0:
		flip()
	
	if grounded:
		if move_dir == 0:
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
