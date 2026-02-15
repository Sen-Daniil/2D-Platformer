extends CharacterBody2D

signal health_changed (new_health)

enum {
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	ATTACK4,
	ATTACK5,
	ATTACK6,
	BLOCK,
	SLIDE,
	DAMAGE,
	DEATH,
	#JUMP,
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var max_health = 120
var health
var gold = 0
var state = MOVE
var combo = false
var attack_cooldown = false
var player_pos
var damsge_basic = 10
var damage_multiplir = 1
var damage_current

func _ready():
	Signals.connect("enemy_attack", Callable (self, "_on_damage_received"))
	health = max_health

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if velocity.y > 0:
		animPlayer.play("Fall")
		
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#state = JUMP
	
	damage_current = damsge_basic * damage_multiplir
		
	match state: 
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK2:
			attack2_state()
		ATTACK3:
			attack3_state()
		ATTACK4:
			attack4_state()
		ATTACK5:
			attack5_state()
		ATTACK6:
			attack6_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
		DAMAGE:
			damage_state()
		DEATH:
			death_state()
		#JUMP:
			#jump_state()
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and not(Input.is_action_pressed("slide1")):
		velocity.y = JUMP_VELOCITY
		animPlayer.play("Jump")

	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)
	


func move_state():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
	if direction == -1:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif direction == 1:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 0
	
	if Input.is_action_pressed("block"):
		state = BLOCK
		
	if Input.is_action_just_pressed("attack") and attack_cooldown == false and velocity.y == 0:
		state = ATTACK
		
	if Input.is_action_pressed("slide1") and velocity.x != 0 and Input.is_action_pressed("slide2") and velocity.y == 0:
		state = SLIDE
		
func block_state():
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE
		
func slide_state():
	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_state():
	damage_multiplir = 1
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE
	
func attack2_state():
	damage_multiplir = 1.2
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack3_state():
	damage_multiplir = 1.4
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK4
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE
	
func attack4_state():
	damage_multiplir = 1.6
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK5
	animPlayer.play("Attack4")
	await animPlayer.animation_finished
	state = MOVE
	
func attack5_state():
	damage_multiplir = 1.8
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK6
	animPlayer.play("Attack5")
	await animPlayer.animation_finished
	state = MOVE
	
func attack6_state():
	damage_multiplir = 2
	animPlayer.play("Attack6")
	await animPlayer.animation_finished
	state = MOVE
	
func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false
	
func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.5).timeout
	attack_cooldown = false
	
func damage_state():
	velocity.x = 0
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = MOVE
	
func death_state():
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
	get_tree().change_scene_to_file.bind("res://scn/Menu/menu.tscn").call_deferred()
	
#func jump_state():	
	#velocity.y = JUMP_VELOCITY
	#animPlayer.play("Jump")
	#await animPlayer.animation_finished
	#state = MOVE
	
func _on_damage_received (enemy_damage):
	if state == BLOCK:
		enemy_damage /= 2
	elif state == SLIDE:
		enemy_damage = 0
	else:
		state = DAMAGE
	health -= enemy_damage
	if health <= 0:
		health = 0
		state = DEATH
		
	
		
	emit_signal("health_changed", health)
	print(health)
	
func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("player_attack", damage_current)
