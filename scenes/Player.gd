extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -150
@export var can_double_jump = false

@onready var walk_sprite = $Walk
@onready var jump_sprite = $Jump
@onready var _animation_player = $AnimationPlayer

func _physics_process(delta):
	velocity.y += delta * gravity 
	
	if is_on_floor():
		if Input.is_action_just_pressed('ui_up'):
			velocity.y = jump_speed
			can_double_jump = true
			jump()
		else:
			land()
	elif not is_on_floor() and can_double_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		can_double_jump = false
		jump()

	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		#scale.x = -1 
		changeDir(true)
		_animation_player.play("walk")

	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		#scale.x = 1 
		changeDir(false)
		_animation_player.play("walk")

	else:
		velocity.x = 0
		_animation_player.stop() #ganti idle nanti 

	if not is_on_floor():
		if velocity.y < 0:
			_animation_player.play("jump")
		else:
			_animation_player.play("fall")

	move_and_slide()

func jump():
	walk_sprite.visible = false
	jump_sprite.visible = true

func land():
	walk_sprite.visible = true
	jump_sprite.visible = false
	
func changeDir(dir):
	walk_sprite.flip_h = dir 
	jump_sprite.flip_h = dir
