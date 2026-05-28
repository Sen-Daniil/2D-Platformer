extends Node2D

@onready var buttons = $Buttons

var SAVE_PATH = "user://savegame.save"



func _on_button_2_pressed() -> void:
	buttons.play()
	await  buttons.finished
	get_tree().quit()


func _on_play_pressed() -> void:
	buttons.play()
	await  buttons.finished
	get_tree().change_scene_to_file("res://scn/Level/level.tscn")
