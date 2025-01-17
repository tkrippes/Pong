class_name Player
extends Area2D

enum PlayerNumber {PLAYER_ONE, PLAYER_TWO}

## The speed of the player.
@export var speed: int = 250
## The player identifier.
@export var player_number: PlayerNumber = PlayerNumber.PLAYER_ONE

var _playable_area: Rect2
var _initial_position: Vector2
var _stop_player: bool = false


func _ready() -> void:
	var screen_rect := get_viewport_rect()
	var size := ($Hitbox as CollisionShape2D).position * 2
	_playable_area = Rect2(screen_rect.position, Vector2(screen_rect.end.x, screen_rect.end.y - size.y))
	
	_initial_position = position


func _process(delta: float) -> void:
	position += _get_velocity_from_input() * delta
	position = position.clamp(_playable_area.position, _playable_area.end)


func reset() -> void:
	position = _initial_position


func stop() -> void:
	_stop_player = true


func play_hit_sound() -> void:
	($HitSound as AudioStreamPlayer2D).play()


func _get_velocity_from_input() -> Vector2:
	if _stop_player:
		return Vector2.ZERO
		
	match player_number:
		PlayerNumber.PLAYER_ONE:
			return _get_velocity_from_player_input("move_player_1_up", "move_player_1_down")
		PlayerNumber.PLAYER_TWO:
			return _get_velocity_from_player_input("move_player_2_up", "move_player_2_down")
		_:
			return Vector2.ZERO


func _get_velocity_from_player_input(move_up_action_name: String,
		move_down_action_name: String) -> Vector2:
	var _velocity := Vector2.ZERO
	if Input.is_action_pressed(move_up_action_name):
		_velocity.y -= 1
	elif Input.is_action_pressed(move_down_action_name):
		_velocity.y += 1
	_velocity = _velocity.normalized() * speed
	
	return _velocity
