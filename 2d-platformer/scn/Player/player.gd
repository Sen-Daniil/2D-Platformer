extends CharacterBody2D



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

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var run_speed = 1

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var stats = $Stats



var state = MOVE
var combo = false
var attack_cooldown = false
var damsge_basic = 10
var damage_multiplir = 1
var damage_current
var recovery = false

func _ready():
	Signals.connect("enemy_attack", Callable (self, "_on_damage_received"))


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if velocity.y > 0:
		animPlayer.play("Fall")
		
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#state = JUMP
	
	Global.player_damage = damsge_basic * damage_multiplir
		
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
	
	Global.player_pos = self.position

func move_state():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("Walk")
			else:
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
	if Input.is_action_pressed("run") and not recovery:
		run_speed = 1.5
		stats.stamina -= stats.run_cost
	else:
		run_speed = 1
	
	if Input.is_action_pressed("block"):
		if stats.stamina > 1 and recovery == false:
				state = BLOCK
		
	if Input.is_action_just_pressed("attack") and attack_cooldown == false and velocity.y == 0 and stats.stamina > stats.stamina_cost:
		if not recovery:
			if recovery == false:
				state = ATTACK
		
	if Input.is_action_pressed("slide1") and velocity.x != 0 and Input.is_action_pressed("slide2") and velocity.y == 0:
		if not recovery:
			stats.stamina_cost = stats.slide_cost
			if stats.stamina > stats.stamina_cost:
				state = SLIDE
		
func block_state():
	stats.stamina -= stats.block_cost
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block") or recovery == true:
		state = MOVE
		
func slide_state():
	
	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplir = 1
	if Input.is_action_just_pressed("attack") and combo == true and  stats.stamina > stats.stamina_cost:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE
	
func attack2_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplir = 1.2
	if Input.is_action_just_pressed("attack") and combo == true and  stats.stamina > stats.stamina_cost:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack3_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplir = 1.4
	if Input.is_action_just_pressed("attack") and combo == true and  stats.stamina > stats.stamina_cost:
		state = ATTACK4
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE
	
func attack4_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplir = 1.6
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina > stats.stamina_cost:
		state = ATTACK5
	animPlayer.play("Attack4")
	await animPlayer.animation_finished
	state = MOVE
	
func attack5_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplir = 1.8
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina > stats.stamina_cost:
		state = ATTACK6
	animPlayer.play("Attack5")
	await animPlayer.animation_finished
	state = MOVE
	
func attack6_state():
	stats.stamina_cost = stats.attack_cost
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
		damage_anim()
	stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state = DEATH	
	


func _on_stats_no_stamina() -> void:
	recovery = true
	await get_tree().create_timer(2).timeout
	recovery = false
	
func damage_anim():
	velocity.x = 0
	self.modulate = Color(1,0,0,1)
	if $AnimatedSprite2D.flip_h == true:
		velocity.x += 200
	else:
		velocity.x -= 200
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2(0,0), 0.04)
	tween.parallel().tween_property(self, "modulate", Color(1,1,1,1), 0.04)
