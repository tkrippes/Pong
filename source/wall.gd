class_name Wall
extends Area2D


func play_hit_sound() -> void:
	($HitSound as AudioStreamPlayer2D).play()
