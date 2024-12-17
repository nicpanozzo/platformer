extends Player
class_name PlayerMulti


var syncPos = Vector2(0,0)
@onready
var animation_p = $AnimationPlayer

@onready var projectile_scene = preload("res://scenes/entities/projectile.tscn")
@onready var camera = $Camera2D  # Assicurati che la Camera2D sia figlio del Player

	
var current_animation = ""

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	get_node("Healthbar").update_healthbar(health, max_health)
	camera.enabled = false
	change_color_healthbar()
	
@rpc("call_local")
func change_color_healthbar():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		get_node("Healthbar").get_child(0).color = Color(0,.9,0)
		camera.enabled = true
	
 
func _physics_process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
			flipping.rpc(abs(sprite.scale.x) * -1)
			
		if Input.is_action_just_pressed("ui_right"):
			sprite.scale.x = abs(sprite.scale.x)
			flipping.rpc(abs(sprite.scale.x))
			
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		syncPos = global_position
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("attack"):
			attack.rpc()
		if Input.is_action_just_pressed("go_down"):
			go_down()
		
		if Input.is_action_just_pressed("ranged_attack"):
			perform_ranged_attack.rpc()
		sync_animation_state()
		move_and_slide()
		
		if position.y > 400:
			die()
	else:
		global_position = global_position.lerp(syncPos, .5)

		
@rpc("any_peer","call_local","reliable")
func flipping(value):
	sprite.scale.x = value


@rpc("any_peer","call_local","unreliable")
func perform_ranged_attack():
	
	print("RANGED")
	# Create the projectile
	var projectile: Projectile = projectile_scene.instantiate()
	
	# Set the velocity based on the player's facing direction
	var direction = null
	if (sprite.scale.x > 0): 
		direction = Vector2.RIGHT 
	else:
		direction = Vector2.LEFT
	projectile.global_position = self.global_position + direction * 40
	get_parent().add_child(projectile)

	# Set the initial position of the projectile
	#projectile.global_position = self.global_position

	projectile.set_direction(direction)

	
	# Optional: Sync the attack animation
	
	attacking = true
	animation_player.play("RangedAttack")
	
func sync_animation_state():
	if !attacking and can_take_damage:
		if velocity.x != 0:
			set_animation("Run")
		else:
			set_animation("Idle")
		if velocity.y < 0:
			set_animation("Jump")
		elif velocity.y > 0:
			set_animation("Fall")

# Set and synchronize animation
func set_animation(anim_name: String) -> void:
	if current_animation != anim_name:
		current_animation = anim_name
		animation_p.play(anim_name)
		sync_animation.rpc(anim_name)

@rpc("any_peer", "unreliable")
func sync_animation(anim_name: String) -> void:
	if current_animation != anim_name:
		current_animation = anim_name
		animation_player.play(anim_name)

@rpc("any_peer","call_local", "reliable")
func attack():
	var overlapping_objects = $Sprite2D/AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage.rpc(1)
			print("taking damage")
		print(parent.name)
		
		
	attacking = true
	animation_player.play("Attack")

@rpc("any_peer","call_local","reliable")
func take_damage(damage: int):
	
	print("health: ", health)
	if can_take_damage:
		animation_player.play("Hit")
		iframes()
		
		health_change(damage)
		print("lesser health: ", health)

func die():
	hide()
	await get_tree().create_timer(1).timeout
	show()
	var index = 0
	health = max_health
	for i in MultiplayerManager.players:
		if str(MultiplayerManager.players[i].id) == name:
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					global_position = spawn.global_position
					GameManage.respawn_player()
					get_node("Healthbar").update_healthbar(health, max_health)
					pass
		index += 1
		
		
	
