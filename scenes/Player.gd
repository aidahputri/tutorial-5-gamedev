extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var dash_speed = 400
@export var crouch_speed = 50
@export var jump_speed = -150
@export var can_double_jump = false

var was_in_air = false
var is_landing = false
var is_crouching = false
var is_dashing = false

@onready var _animation_player = $AnimatedSprite2D
@onready var _audio_player = $WalkAudio

func _physics_process(delta):
	velocity.y += delta * gravity

	var speed = walk_speed

	if Input.is_action_pressed("ui_shift") and not is_crouching:
		speed = dash_speed
		is_dashing = true
	else:
		is_dashing = false

	if is_crouching:
		speed = crouch_speed

	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		_animation_player.flip_h = true
		if is_on_floor():
			if is_crouching:
				_animation_player.play("crouching")
			elif is_dashing:
				_animation_player.play("dash")
			else:
				_animation_player.play("walk")
				if not _audio_player.playing:
					_audio_player.play()

	# Pergerakan ke kanan
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		_animation_player.flip_h = false
		if is_on_floor():
			if is_crouching:
				_animation_player.play("crouching")
			elif is_dashing:
				_animation_player.play("dash")
			else:
				_animation_player.play("walk")
				if not _audio_player.playing:
					_audio_player.play()

	else:
		velocity.x = 0
		if is_on_floor() and not was_in_air and not is_landing and not is_crouching:
			_animation_player.play("idle")
		_audio_player.stop()

	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		if not is_crouching:
			_animation_player.play("crouching")
			is_crouching = true

	if Input.is_action_just_released("ui_down"):
		_animation_player.play("idle")
		is_crouching = false

	if is_on_floor():
		if was_in_air:
			_animation_player.play("landing")
			is_landing = true
			was_in_air = false
			await get_tree().create_timer(0.1).timeout
			is_landing = false

		if Input.is_action_just_pressed('ui_up'):
			velocity.y = jump_speed
			can_double_jump = true
			_animation_player.play("jump")
			was_in_air = true

	elif not is_on_floor():
		is_crouching = false
		if velocity.y < 0:
			_animation_player.play("jump")
			_audio_player.stop()
		elif velocity.y > 0:
			_animation_player.play("fall")
			_audio_player.stop()

		if can_double_jump and Input.is_action_just_pressed('ui_up'):
			velocity.y = jump_speed
			can_double_jump = false
			_animation_player.play("jump")

	move_and_slide()
