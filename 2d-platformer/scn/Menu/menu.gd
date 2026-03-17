extends Node2D

var SAVE_PATH = "user://savegame.save"

func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/Level/level.tscn")
