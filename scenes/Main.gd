extends Node2D

@onready var tiger_cat = $TigerCat/AnimatedSprite2D
@onready var black_cat = $BlackCat/AnimatedSprite2D
@onready var _cat_audio = $CatAudio

@onready var area1 = $TigerCat
@onready var area2 = $BlackCat

var area1_entered = false
var area2_entered = false

func _on_tiger_cat_body_entered(body):
	if body.name == "Player":
		area1_entered = true
		_cat_audio.play()
		tiger_cat.hide()
		check_win_condition()

func _on_black_cat_body_entered(body):
	if body.name == "Player":
		area2_entered = true
		_cat_audio.play()
		black_cat.hide()
		check_win_condition()
		
func check_win_condition():
	if area1_entered and area2_entered:
		print("🎉 You Win!")
		call_deferred("show_victory_screen")
		
func show_victory_screen():
	var victory_card = get_tree().get_first_node_in_group("VictoryCard")
	if victory_card:
		victory_card.visible = true

func _on_button_pressed():
	print("Reset button clicked!")
	call_deferred("change_scene", "res://scenes/Main.tscn")
	
func change_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
