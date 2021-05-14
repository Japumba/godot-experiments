extends KinematicBody2D

# Movespeed in frames per second
export (float) var move_speed = 200;
export (float) var jump_speed = -600;
export (float) var gravity = 2000;
export (float) var acceleration = 0.5;
export (float) var friction = 0.1;
export (float) var fast_fall_speed = 400;
var velocity = Vector2.ZERO
var fast_falling: bool = false


func _physics_process(delta) -> void:
	get_input()
	
	if !is_on_floor() and Input.is_action_just_pressed("down"):
		velocity.y = fast_fall_speed
	
	var speed_delta =  gravity * delta
	
	velocity.y += speed_delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed


func _process(delta):
	if(abs(velocity.x) < 5):
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("walk")

func get_input() -> void:
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * move_speed, acceleration)
		$AnimatedSprite.flip_h = dir == -1
	else:
		velocity.x = lerp(velocity.x, 0, friction)
