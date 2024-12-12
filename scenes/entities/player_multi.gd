extends Player


var syncPos = Vector2(0,0)

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
 
func _physics_process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			
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
		syncPos = global_position
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
	else:
		global_position = global_position.lerp(syncPos, .5)
