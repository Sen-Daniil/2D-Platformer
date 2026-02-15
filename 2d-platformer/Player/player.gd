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
	SLIDE
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var health = 100
var gold = 0
var state = MOVE
var combo = false
var attack_cooldown = false

func _physics_process(delta: float) -> void:
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
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("attack") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		#animPlayer.play("Jump")
	
	if velocity.y > 0:
		animPlayer.play("Fall")
		
	if health <= 0:
		health = 0
		animPlayer.play("Death")
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")

	move_and_slide()
	


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
	elif direction == 1:
		anim.flip_h = false
	
	if Input.is_action_pressed("block"):
		state = BLOCK
		
	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		state = ATTACK
		
	if Input.is_action_pressed("slide1") and velocity.x != 0 and Input.is_action_pressed("slide2"):
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
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE
	
func attack2_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack3_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK4
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE
	
func attack4_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK5
	animPlayer.play("Attack4")
	await animPlayer.animation_finished
	state = MOVE
	
func attack5_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK6
	animPlayer.play("Attack5")
	await animPlayer.animation_finished
	state = MOVE
	
func attack6_state():
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
	
	
	
	
	
	

		
