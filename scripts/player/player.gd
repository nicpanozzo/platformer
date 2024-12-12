extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@export var attacking = false

var max_healt = 2
var healt = 0

var can_take_damage = true
signal health_signal(int)

func health_change(damage: int):
	healt -= damage
	if damage >= 0:
		GameManage.damage_taken += damage
	if healt <= 0:
			die() 
	emit_signal("health_signal", damage)

func _ready() -> void:
	healt = max_healt
	GameManage.player = self
	GameManage.damage_taken = 0



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("go_down"):
		go_down()
		
func go_down():
	if is_on_floor():
		position.y += 5
	
func attack():
	var overlapping_objects = $Sprite2D/AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage(1)
		print(parent.name)
		
		
	attacking = true
	animation_player.play("Attack")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		
	if Input.is_action_just_pressed("ui_right"):
		sprite.scale.x = abs(sprite.scale.x)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	move_and_slide()
	
	if position.y > 400:
		die()

func update_animation():
	if !attacking && can_take_damage:
		if velocity.x !=0:
			animation_player.play("Run")
		else:
			animation_player.play("Idle")
		
		if velocity.y < 0:
			animation_player.play("Jump")
		if velocity.y > 0:
			animation_player.play("Fall")
func take_damage(damage: int):
	print("health: ", healt)
	if can_take_damage:
		animation_player.play("Hit")
		iframes()
		
		health_change(damage)
		print("lesser health: ", healt)
		

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
 
func die():
	
	GameManage.respawn_player()
