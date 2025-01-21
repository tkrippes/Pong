class_name Player
extends CharacterBody2D

enum PlayerNumber {PLAYER_ONE, PLAYER_TWO}

## The speed of the player.
@export var speed: int = 450
## The player identifier.
@export var player_number: PlayerNumber = PlayerNumber.PLAYER_ONE

var _initial_position: Vector2


func _ready() -> void:
	_initial_position = position


func _physics_process(delta: float) -> void:
	var _collision := move_and_collide(_get_velocity_from_input() * delta)


func reset() -> void:
	position = _initial_position


func _get_velocity_from_input() -> Vector2:
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
	if Input.is_action_pressed(move_down_action_name):
		_velocity.y += 1
	_velocity = _velocity.normalized() * speed
	
	return _velocity
