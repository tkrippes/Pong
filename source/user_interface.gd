class_name UserInterface
extends Control


func update_score_board(player_1_score: int, player_2_score: int) -> void:
	($ScoreBoard as Label).text = "%d : %d" % [player_1_score, player_2_score]


func hide_screens() -> void:
	($ReadyLabel as Label).hide()
	($WinLabel as Label).hide()


func show_ready_screen() -> void:
	($ReadyLabel as Label).show()
	($WinLabel as Label).hide()


func show_win_screen(winning_player_number: int) -> void:
	var win_label := $WinLabel as Label
	win_label.text = "PLAYER %d\nWINS" % winning_player_number
	win_label.show()
	($ReadyLabel as Label).hide()
