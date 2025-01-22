extends AudioStreamPlayer2D

## The delay in seconds after which the background music is started.
@export var play_delay: float = 2.5
 

func play_delayed() -> void:
	await get_tree().create_timer(play_delay).timeout
	play()
