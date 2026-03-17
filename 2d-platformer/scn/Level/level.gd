extends Node2D


@onready var player = $Player/Player

var skeleton_preload = preload("res://scn/Mobs/skeleton.tscn")
var goblin_preload = preload("res://scn/Mobs/goblin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gold = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func enemy_spawn():
	var rng = randi_range(1, 2)
	if rng == 0:
		skeloton_spawn()
	else:
		goblin_spawn()

func _on_spawner_timeout() -> void:
	enemy_spawn()
	
func _on_spawner_2_timeout() -> void:
	enemy_spawn()
	
func skeloton_spawn():
	var skeleton = skeleton_preload.instantiate()
	skeleton.position = Vector2(randi_range(100, 200),550)
	$Mobs.add_child(skeleton)
	
func skeloton_spawn2():
	var skeleton = skeleton_preload.instantiate()
	skeleton.position = Vector2(randi_range(1000, 1200),550)
	$Mobs.add_child(skeleton)
	
func goblin_spawn():
	var goblin = goblin_preload.instantiate()
	goblin.position = Vector2(randi_range(100, 200),550)
	$Mobs.add_child(goblin)
