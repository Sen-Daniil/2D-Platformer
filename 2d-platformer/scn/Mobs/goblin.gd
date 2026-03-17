extends Enemy

func _on_mobs_health_no_health() -> void:
	state = DEATH
	
func _on_mobs_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE
