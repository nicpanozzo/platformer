extends Player


var syncPos = Vector2(0,0)
@onready
var animation_p = $AnimationPlayer

var current_animation = ""

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	get_node("Healthbar").update_healthbar(health, max_health)
	change_color_healthbar()
	
@rpc("call_local")
func change_color_healthbar():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		get_node("Healthbar").get_child(0).color = Color(0,.9,0)
	
 
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
		sync_animation_state()
		move_and_slide()
		
		if position.y > 400:
			die()
	else:
		global_position = global_position.lerp(syncPos, .5)

		
@rpc("any_peer","call_local","reliable")
func flipping(value):
	sprite.scale.x = value
	
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
		
		
	
