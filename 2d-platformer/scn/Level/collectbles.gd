extends Node2D

var coin_preload = preload("res://scn/collectbles/coin.tscn")

func _ready():
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died"))
	
func _on_enemy_died(enemy_position):
	coin_spawn(enemy_position)
	
func coin_spawn(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	add_child(coin)
