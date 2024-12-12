extends CharacterBody2D
class_name Saber


var SPEED = -60.0
const JUMP_VELOCITY = -400.
@export var SCORE_VALUE = 100
var facing_right = false

@export var healt = 2

@onready var animation_player = $AnimationPlayer
@export var animation = "Run"

var dead = false

var oldSPEED

func _ready() -> void:
	animation_player.play(animation)
	self.duplicate()
	
	
func stopMoving():
	oldSPEED = SPEED
	SPEED = 0

func resumeMoving():
	SPEED = oldSPEED
	animation_player.play("Run")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if $RayCast2D2.is_colliding():
		var collider = $RayCast2D2.get_collider()
		if collider is not Player && is_on_floor():
			flip()

	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()

	velocity.x = SPEED

	move_and_slide()
	
func flip():
	#if $AnimationPlayer.current_animation != "Run":
	if dead:
		pass
	animation_player.play("Run")
	facing_right = !facing_right
	
	scale.x = abs(scale.x) *-1
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead:
		area.get_parent().take_damage(1)


func take_damage(damage:int):
	animation_player.play("Hit")
	
	healt -= damage
	if healt <= 0:
		die()
		
func die():
	GameManage.score += SCORE_VALUE
	SPEED = 0
	dead = true
	animation_player.play("Die")
	#queue_free()


func _on_head_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Adjust the bounce strength to fit your game
		var bounce_strength = -300
		body.velocity.y = bounce_strength # Replace with function body.
		take_damage(2)
