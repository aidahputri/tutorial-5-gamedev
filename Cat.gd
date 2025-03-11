extends Area2D

@onready var _cat_animation_player = $AnimatedSprite2D

func _process(_delta):
	_cat_animation_player.play("idle")
	_cat_animation_player.flip_h = true
