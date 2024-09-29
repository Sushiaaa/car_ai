extends CharacterBody2D

var wheel_base = 70  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees

var steer_angle

var engine_power = 500  # Forward acceleration force.

var acceleration = Vector2.ZERO

var braking = -400
var max_speed_reverse = 200

var friction = -0.9
var drag = -0.0015

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

var input = [0.0, 0.0, 0.0, 0.0];

func _physics_process(delta):
	acceleration = Vector2.ZERO
	ai_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func ai_input():
	var turn = 0;
	turn+= clamp(input[2]-input[3],-1, 1);
	steer_angle = turn * steering_angle
	acceleration = (transform.x * engine_power * clamp(input[1], 0, 1)) +(transform.x * braking * clamp(input[0], 0, 1));
	acceleration = -Vector2(max(acceleration.x, 0), max(acceleration.y, 0))

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
