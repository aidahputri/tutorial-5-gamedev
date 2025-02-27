extends Area2D

@onready var idle_sprite = $Idle
@onready var _cat_animation_player = $CatAnimationPlayer

func _process(_delta):
	_cat_animation_player.play("idle")
	idle_sprite.flip_h = true

func show_victory_screen():
	var victory_card = get_tree().get_first_node_in_group("VictoryCard")
	if victory_card:
		victory_card.visible = true

func change_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		print("Reached objective!")
		call_deferred("show_victory_screen")

func _on_button_pressed():
	print("Reset button clicked!")
	call_deferred("change_scene", "res://scenes/Main.tscn")
