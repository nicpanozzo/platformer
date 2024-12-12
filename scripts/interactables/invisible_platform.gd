extends StaticBody2D


var showing = false




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && not showing:
		showing = true
		$AnimationPlayer.play("FadeIn")
