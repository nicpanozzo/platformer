extends StaticBody2D
class_name Cannon


@export var SCORE_VALUE = 250
var cannon_ball = load("res://scenes/Interactable/cannon_ball.tscn")
var debris = load("res://scenes/Interactable/cannon_debris.tscn")

@export var shooting: bool
var firerate = 2.0

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $Firepoint


var max_health = 3
var health

func _ready() -> void:
	health = max_health
	shooting = true
	shoot()


	

	
	
func shoot():
	while shooting:
		animation_player.play("Fire")
		await get_tree().create_timer(firerate).timeout
		
func fire():
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)
		
func take_damage(damage_amount):
	health -= damage_amount
	
	get_node("Healthbar").update_healthbar(health, max_health)
	
	animation_player.play("Hit")
	if health <= 0:
		die()
	#shoot()
		
func die():
	GameManage.score += SCORE_VALUE
	var spawned_debris = debris.instantiate()
	spawned_debris.global_position = position
	spawned_debris.scale.x = scale.x
	spawned_debris.get_child(1).play("Crumble")
	get_tree().get_root().get_child(1).add_child(spawned_debris)
	queue_free()
