class_name Ball
extends RigidBody2D


## The initial speed of the ball.
@export var initial_speed: int = 300
## The maximum speed of the ball.
@export var max_speed: int = 1000
## The speed increment of the ball whenever it bounces off a player.
@export var speed_increment: int = 20
## The maximum angle deviation of the ball.
## The initial angle is chosen randomly between - the maximum value and the maximum value.
## Which player the ball is initially moving towards is chosen randomly at the start as well.
@export_range(0, 60, 1, "radians_as_degrees")
var max_angle_deviation: float = PI / 4
## The maximum random angle deviation of the ball during bouncing.
## During each bounce, a random deviation between - the maximum value and the maximum value is applied.
@export_range(0, 30, 1, "radians_as_degrees")
var max_random_bounce_angle_deviation: float = PI / 12

var _velocity: Vector2
var _initial_position: Vector2


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
	if event.is_action_pressed("enter") and not visible and not _stop_ball:
		start()


func start() -> void:
	await get_tree().create_timer(0.3).timeout
	var player_direction: int = randi_range(0, 1)
	var angle := randf_range(-max_angle_deviation, max_angle_deviation) + PI * player_direction
	
	show()
	
	_velocity = Vector2(1, 0) * initial_speed
	_velocity = _velocity.rotated(angle)
	_limit_velocity_angle()


func reset() -> void:
	hide()
	
	position = _initial_position
	rotation = 0.0
	angular_velocity = 0.0
	_velocity = Vector2.ZERO
	
	($DestroyedSound as AudioStreamPlayer2D).play()


func _bounce(collision: KinematicCollision2D) -> void:
	var normal := collision.get_normal()
	_velocity = _velocity.bounce(normal)
	
	_add_random_velocity_angle_deviation()
	_limit_velocity_angle()


func _add_random_velocity_angle_deviation() -> void:
	var angle := randf_range(- max_random_bounce_angle_deviation, max_random_bounce_angle_deviation)
	_velocity = _velocity.rotated(angle)


func _limit_velocity_angle() -> void:
	var angle := _velocity.angle()
	
	if angle > - PI + max_angle_deviation and angle < - PI / 2: 
		_velocity = _velocity.length() * Vector2(1, 0).rotated(- PI + max_angle_deviation)
	elif angle >= - PI / 2 and angle < - max_angle_deviation:
		_velocity = _velocity.length() * Vector2(1, 0).rotated(- max_angle_deviation)
	elif angle > max_angle_deviation and angle < PI / 2:
		_velocity = _velocity.length() * Vector2(1, 0).rotated(max_angle_deviation)
	elif angle >= PI / 2 and angle < PI - max_angle_deviation:
		_velocity = _velocity.length() * Vector2(1, 0).rotated(PI - max_angle_deviation)


func _increase_speed() -> void:
	var velocity_direction := _velocity.normalized()
	_velocity += velocity_direction * speed_increment
	if _velocity.length() > max_speed:
		_velocity = velocity_direction * max_speed
