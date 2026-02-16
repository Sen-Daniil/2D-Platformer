extends Node2D


@onready var player = $Player/Player

var skeleton_preload = preload("res://scn/Mobs/skeleton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gold = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_spawner_timeout() -> void:
	skeloton_spawn()
	
func skeloton_spawn():
	var skeleton = skeleton_preload.instantiate()
	skeleton.position = Vector2(randi_range(-100, 1500),550)
	$Mobs.add_child(skeleton)
