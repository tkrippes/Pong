extends AudioStreamPlayer2D


## The delay in seconds after which the win sound is played.
@export var play_delay: float = 0.5
 

func play_delayed() -> void:
	await get_tree().create_timer(play_delay).timeout
	play()
