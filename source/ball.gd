class_name Ball
extends Area2D


## The initial speed of the ball.
@export var initial_speed: int = 250
## The maximum speed of the ball.
@export var max_speed: int = 1000
## The speed increment of the ball whenever it bounces off a player.
@export var speed_increment: int = 20
## The maximum angle derivation of the ball when it starts moving.
## The angle is chosen randomly between 0 and the maximum value.
## Which player the ball is initially moving towards is chosen randomly.
@export_range(45, 60, 1, "suffix:°")
var max_start_angle_derivation: int

var _velocity: Vector2
var _initial_position: Vector2
var _stop_ball: bool = false


func _ready() -> void:
	hide()
	_initial_position = position


func _process(delta: float) -> void:
	position += _velocity * delta


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not visible and not _stop_ball:
		start()


func start() -> void:
	var player_direction: int = randi_range(0, 1)
	var angle := randf_range(-PI / 3, PI / 3) + PI * player_direction
	
	show()
	
	var direction := Vector2(1, 0)
	_velocity = direction.normalized() * initial_speed
	_velocity = _velocity.rotated(angle + PI * randi_range(0, 1))


func reset() -> void:
	hide()
	position = _initial_position
	_velocity = Vector2.ZERO
	($DestroyedSound as AudioStreamPlayer2D).play()


func stop() -> void:
	_stop_ball = true


func _on_area_entered(body: Node) -> void:
	if (body is Wall):
		_velocity.y *= -1
		(body as Wall).play_hit_sound()
	elif (body is Player):
		_velocity.x *= -1
		_increase_speed()
		(body as Player).play_hit_sound()


func _increase_speed() -> void:
	var velocity_direction := _velocity.normalized()
	_velocity += velocity_direction * speed_increment
	if _velocity.length() > max_speed:
		_velocity = velocity_direction * max_speed
