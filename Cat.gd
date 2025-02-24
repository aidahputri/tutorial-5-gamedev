extends CharacterBody2D

@onready var idle_sprite = $Idle
@onready var _cat_animation_player = $CatAnimationPlayer

func _process(delta):
	_cat_animation_player.play("idle")
	idle_sprite.flip_h = true
