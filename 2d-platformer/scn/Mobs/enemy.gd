extends CharacterBody2D
class_name Enemy

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

var player = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 20
var move_speed = 150

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()
				
func _ready():
	state = CHASE

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == CHASE:
		chase_state()

	move_and_slide()
	
	player = Global.player_pos
	
func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK
	
func idle_state():
	velocity.x = 0
	animPlayer.play("Idle")
	state = CHASE
	
func attack_state():
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = RECOVER
	
func chase_state():
	velocity.x = 0
	animPlayer.play("Run")
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0
	velocity.x = direction.x * move_speed
		
func damage_state():
	velocity.x = 0
	direction = (player - self.position).normalized()
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE
	
func death_state():
	velocity.x = 0
	Signals.emit_signal('enemy_died', position)
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
	
func recover_state():
	velocity.x = 0
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE
		
func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)

func _on_run_timeout() -> void:
	move_speed = move_toward(move_speed, randi_range(120, 170), 100)
