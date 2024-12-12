extends Node2D

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
		replace()

func replace():
	var newX = rng.randf_range(50,get_viewport().get_visible_rect().size.x)
	var newY = rng.randf_range(0,get_viewport().get_visible_rect().size.y)
	position = Vector2(newX,newY)
		

func is_overlapping(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	# Create query parameters for the intersection check
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	
	# Perform the intersection check
	var result = space_state.intersect_point(query)
	return result.size() > 0
