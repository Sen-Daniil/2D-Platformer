extends Enemy

const JUMP_VELOCITY = -400.0

func _on_mobs_health_no_health() -> void:
	state = DEATH
	
func _on_mobs_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE


func _on_area_2d_body_entered(body: Node2D) -> void:
	velocity.y = JUMP_VELOCITY
