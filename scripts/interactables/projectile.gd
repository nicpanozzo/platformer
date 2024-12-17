extends RigidBody2D
class_name Projectile


@export var speed = 400
@export var damage = 1


func _ready():
	# Destroy the projectile after a few seconds to avoid memory leaks
	await get_tree().create_timer(5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		position += linear_velocity * delta

func set_direction(direction: Vector2):
	linear_velocity = direction * speed




func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if linear_velocity.length() > 10:
		if parent.has_method("take_damage"):
			parent.take_damage(1)
		print(parent.name)
