class_name UserInterface
extends Control


func _ready() -> void:
	show_ready_screen()

func _unhandled_input(event: InputEvent) -> void:
	var ready_label := $ReadyLabel as Label
	if event.is_action_pressed("enter") && ready_label.visible:
		ready_label.hide()


func update_score_board(player_1_score: int, player_2_score: int) -> void:
	($ScoreBoard as Label).text = "%d : %d" % [player_1_score, player_2_score]


func show_ready_screen() -> void:
	($ReadyLabel as Label).show()
	($WinLabel as Label).hide()


func show_win_screen(player_number: int) -> void:
	var win_label := $WinLabel as Label
	win_label.text = "Player %d\nWins" % player_number
	win_label.show()
	($ReadyLabel as Label).hide()
