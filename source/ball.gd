class_name Ball
extends RigidBody2D


## The initial speed of the ball.
@export var initial_speed: int = 250
## The maximum speed of the ball.
@export var max_speed: int = 1000
## The speed increment of the ball whenever it bounces off a player.
@export var speed_increment: int = 20
## The maximum angle derivation of the ball when it starts moving.
## The angle is chosen randomly between 0 and the maximum value.
## Which player the ball is initially moving towards is chosen randomly.
@export_range(0, 60, 1, "radians_as_degrees")
var max_start_angle_derivation: float = PI / 4

var _velocity: Vector2
var _initial_position: Vector2
var _stop_ball: bool = false


func _ready() -> void:
	hide()
	_initial_position = position


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(_velocity * delta)
	
	if collision:
		var collider := collision.get_collider()
		if collider is Wall or collider is Player:
			_bounce(collision)
			
			if collider is Wall:
				($WallHitSound as AudioStreamPlayer2D).play()
			elif collider is Player:
				_increase_speed()
				($PlayerHitSound as AudioStreamPlayer2D).play()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not visible and not _stop_ball:
		start()


func start() -> void:
	var player_direction: int = randi_range(0, 1)
	var angle := randf_range(-max_start_angle_derivation, max_start_angle_derivation) + PI * player_direction
	
	show()
	
	_velocity = Vector2(1, 0) * initial_speed
	_velocity = _velocity.rotated(angle)


func reset() -> void:
	hide()
	position = _initial_position
	_velocity = Vector2.ZERO
	($DestroyedSound as AudioStreamPlayer2D).play()


func stop() -> void:
	_stop_ball = true


func _bounce(collision: KinematicCollision2D) -> void:
	var normal := collision.get_normal()
	_velocity = _velocity.bounce(normal)


func _increase_speed() -> void:
	var velocity_direction := _velocity.normalized()
	_velocity += velocity_direction * speed_increment
	if _velocity.length() > max_speed:
		_velocity = velocity_direction * max_speed
