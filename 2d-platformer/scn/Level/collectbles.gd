extends Node2D

var coin_preload = preload("res://scn/collectbles/coin.tscn")

func _ready():
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died"))
	
func _on_enemy_died(enemy_position):
	for i in randi_range(1, 3):
		coin_spawn(enemy_position)
		await get_tree().create_timer(0.05).timeout
	
func coin_spawn(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	call_deferred("add_child", coin)
