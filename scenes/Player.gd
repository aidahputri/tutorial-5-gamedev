extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var dash_speed = 400
@export var crouch_speed = 50
@export var jump_speed = -150
@export var can_double_jump = false

@onready var walk_sprite = $Walk
@onready var jump_sprite = $Jump
@onready var idle_sprite = $Idle
@onready var fall_sprite = $Fall
@onready var landing_sprite = $Landing
@onready var crouching_sprite = $Crouching
@onready var dash_sprite = $Dash
@onready var _animation_player = $AnimationPlayer

var was_in_air = false
var is_landing = false
var is_crouching = false
var is_dashing = false

func _physics_process(delta):
	velocity.y += delta * gravity

	var speed = walk_speed

	# Jika shift ditekan dan tidak crouching, gunakan dash_speed
	if Input.is_action_pressed("ui_shift") and not is_crouching:
		speed = dash_speed
		is_dashing = true
	else:
		is_dashing = false

	# Jika sedang crouching, gunakan crouch_speed
	if is_crouching:
		speed = crouch_speed

	# Pergerakan ke kiri
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		flip_sprites(true)
		if is_on_floor():
			if is_crouching:
				set_sprite_visibility("crouching")
				_animation_player.play("crouching")
			elif is_dashing:
				set_sprite_visibility("dash")
				_animation_player.play("dash")
			else:
				set_sprite_visibility("walk")
				_animation_player.play("walk")

	# Pergerakan ke kanan
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		flip_sprites(false)
		if is_on_floor():
			if is_crouching:
				set_sprite_visibility("crouching")
				_animation_player.play("crouching")
			elif is_dashing:
				set_sprite_visibility("dash")
				_animation_player.play("dash")
			else:
				set_sprite_visibility("walk")
				_animation_player.play("walk")

	# Jika tidak bergerak, tetap idle (hanya jika tidak crouching)
	else:
		velocity.x = 0
		if is_on_floor() and not was_in_air and not is_landing and not is_crouching:
			set_sprite_visibility("idle")
			_animation_player.play("idle")

	# Crouching (jongkok)
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		if not is_crouching:
			set_sprite_visibility("crouching")
			_animation_player.play("crouching")
			is_crouching = true

	if Input.is_action_just_released("ui_down"):
		set_sprite_visibility("idle")
		_animation_player.play("idle")
		is_crouching = false

	# Jumping
	if is_on_floor():
		if was_in_air:
			set_sprite_visibility("landing")
			_animation_player.play("landing")
			is_landing = true
			was_in_air = false
			await get_tree().create_timer(0.1).timeout
			is_landing = false

		if Input.is_action_just_pressed('ui_up'):
			velocity.y = jump_speed
			can_double_jump = true
			set_sprite_visibility("jump")
			_animation_player.play("jump")
			was_in_air = true

	elif not is_on_floor():
		is_crouching = false
		if velocity.y < 0:
			set_sprite_visibility("jump")
			_animation_player.play("jump")
		elif velocity.y > 0:
			set_sprite_visibility("fall")
			_animation_player.play("fall")

		if can_double_jump and Input.is_action_just_pressed('ui_up'):
			velocity.y = jump_speed
			can_double_jump = false
			set_sprite_visibility("jump")
			_animation_player.play("jump")

	move_and_slide()

func set_sprite_visibility(state: String):
	walk_sprite.visible = false
	jump_sprite.visible = false
	idle_sprite.visible = false
	fall_sprite.visible = false
	landing_sprite.visible = false
	crouching_sprite.visible = false
	dash_sprite.visible = false 

	match state:
		"idle":
			idle_sprite.visible = true
		"walk":
			walk_sprite.visible = true
		"jump":
			jump_sprite.visible = true
		"fall":
			fall_sprite.visible = true
		"landing":
			landing_sprite.visible = true
		"crouching":
			crouching_sprite.visible = true
		"dash":
			dash_sprite.visible = true

func flip_sprites(is_left: bool):
	walk_sprite.flip_h = is_left
	jump_sprite.flip_h = is_left
	idle_sprite.flip_h = is_left
	fall_sprite.flip_h = is_left
	landing_sprite.flip_h = is_left
	crouching_sprite.flip_h = is_left
	dash_sprite.flip_h = is_left
