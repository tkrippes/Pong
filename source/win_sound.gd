extends AudioStreamPlayer2D
 

func play_delayed() -> void:
	await get_tree().create_timer(0.5).timeout
	play()
