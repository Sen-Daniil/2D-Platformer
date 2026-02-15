extends Node2D

@onready var helt_bar = $CanvasLayer/HelthBar
@onready var player = $Player/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	helt_bar.max_value = player.max_health
	helt_bar.value = helt_bar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_health_changed(new_health: Variant) -> void:
	helt_bar.value = new_health
