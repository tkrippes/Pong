extends Node

## The signal sent when the game is over.
signal game_ended

## The score needed to win the game.
@export var win_score: int = 9

var _player_1_score: int = 0
var _player_2_score: int = 0


func _on_player_1_scored(body: Node2D) -> void:
	if body is Ball:
		_player_1_score += 1
		if _player_1_score < win_score:
			_start_new_round()
		else:
			_end_game(1)


func _on_player_2_scored(body: Node2D) -> void:
	if body is Ball:
		_player_2_score += 1
		if _player_2_score < win_score:
			_start_new_round()
		else:
			_end_game(2)


func _start_new_round() -> void:
	_update_score()
	($UserInterface as UserInterface).show_ready_screen()
	_reset()


func _update_score() -> void:
	($UserInterface as UserInterface).update_score_board(_player_1_score, _player_2_score)


func _reset() -> void:
	($Ball as Ball).reset()
	($Player1 as Player).reset()
	($Player2 as Player).reset()


func _end_game(winning_player_number: int) -> void:
	_update_score()
	($UserInterface as UserInterface).show_win_screen(winning_player_number)
	_reset()
	game_ended.emit()
