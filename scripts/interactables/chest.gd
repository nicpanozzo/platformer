extends Node2D

var healt = 2

func take_damage(damage: int):
	healt -= damage
	print("healt: ", healt)
	if healt <=0:
		open()
		

func open():
	print("opened")
	const image = preload("res://Palm Tree Island/Sprites/Objects/Chest/Chest Open 07.png")
	$Sprite2D.texture = image
	
	#$Sprite2D.texture = image
	#queue_free()

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
