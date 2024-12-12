extends Control


@onready var fill_max = $ColorRect.size.x
var fill_amount: float

func update_healthbar(health,max):
	fill_amount = (float(health)/ max) * fill_max
	$ColorRect.size.x = fill_amount
	
