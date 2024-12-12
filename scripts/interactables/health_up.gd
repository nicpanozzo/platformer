extends Node2D



func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.get_parent() is Player && visible:
		area.get_parent().health_change(-1)
		
		hide_with_collision()
		await get_tree().create_timer(5).timeout
		#process_mode = Node.ProcessMode.PROCESS_MODE_INHERIT
		show_with_collision()

func set_visibility(visible: bool):
	self.visible = visible  # Mostra o nasconde il nodo

	# Trova tutti i CollisionShape2D figli e abilita/disabilita in base alla visibilità
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = not visible  # Disabilita la collisione se nascosto

# Esempio di uso:
func hide_with_collision():
	set_visibility(false)  # Nasconde il nodo e disabilita le collisioni

func show_with_collision():
	set_visibility(true)  # Mostra il nodo e riabilita le collisioni
