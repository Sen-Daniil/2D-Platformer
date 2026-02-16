extends CanvasLayer

signal no_stamina ()

@onready var health_bar = $HelthBar
@onready var stamina_bar = $Stamina
@onready var helth_text = $"../HelthText"
@onready var health_anim = $"../HealthAnim"

var max_health = 120
var stamina_cost = 1
var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.4
var old_health = max_health


var stamina = 50:
	set(value):
		stamina = value
		if stamina < 1:
			emit_signal("no_stamina")
var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		helth_text.text = str(difference)
		old_health = health
		if difference < 0:
			health_anim.play("damage_received")
		elif difference > 0:
			health_anim.play("Health_riceived")
		

func _ready():
	helth_text.modulate.a = 0
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
		
func _process(delta: float) -> void:
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 10 * delta
		
func stamiba_consumtion():
	stamina -= stamina_cost
		


func _on_health_regen_timeout() -> void:
	health += 1
