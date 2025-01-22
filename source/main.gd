extends Node

enum GameState {
	GAME_STARTED,
	ROUND_STARTED,
	ROUND_ENDED,
	GAME_ENDED
}

## The signal emitted when a game started.
signal game_started
## The signal emitted when a round started.
signal round_started
## The signal emitted when a round ended.
signal round_ended
## The signal emitted when the game is over.
signal game_ended
## The signal emitted when the scores are updated.
signal scores_updated(player_1_score: int, player_2_score: int)
## The signal semitted when a player wins
signal player_won(winning_player_number: int)

## The score needed to win the game.
@export var win_score: int = 9
## The delay between pressing enter and a new round starting.
@export var start_round_delay: float = 0.25
## The delay between the old game ending and the new game starting.
@export var start_new_game_delay: float = 3.0


var _game_state: GameState = GameState.GAME_STARTED
var _player_1_score: int = 0
var _player_2_score: int = 0


func _ready() -> void:
	_start_game()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		match _game_state:
			GameState.GAME_STARTED, GameState.ROUND_ENDED:
				_start_new_round()


func _on_player_1_scored(body: Node2D) -> void:
	if body is Ball:
		_player_1_score += 1
		scores_updated.emit(_player_1_score, _player_2_score)
		if _player_1_score < win_score:
			_end_round()
		else:
			_end_game(1)


func _on_player_2_scored(body: Node2D) -> void:
	if body is Ball:
		_player_2_score += 1
		scores_updated.emit(_player_1_score, _player_2_score)
		if _player_2_score < win_score:
			_end_round()
		else:
			_end_game(2)


func _start_game() -> void:
	_reset_player_scores()
	_game_state = GameState.GAME_STARTED
	game_started.emit()


func _reset_player_scores() -> void:
	_player_1_score = 0
	_player_2_score = 0
	scores_updated.emit(_player_1_score, _player_2_score)


func _start_new_round() -> void:
	await get_tree().create_timer(start_round_delay).timeout
	_game_state = GameState.ROUND_STARTED
	round_started.emit()


func _end_round() -> void:
	_game_state = GameState.ROUND_ENDED
	round_ended.emit()


func _end_game(winning_player_number: int) -> void:
	player_won.emit(winning_player_number)
	_game_state = GameState.GAME_ENDED
	game_ended.emit()
	
	await get_tree().create_timer(start_new_game_delay).timeout
	_start_game()
