extends CharacterBody2D

@export var movement_speed : float = 100
@onready var animated_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")
	face_right()

func play_running_animation():
	animated_sprite.find_child("Body").hframes = 6
	animated_sprite.find_child("Body").vframes = 2
	animation_player.play("Running")

func play_idle_animation():
	animated_sprite.find_child("Body").hframes = 4
	animated_sprite.find_child("Body").vframes = 1
	animation_player.play("Idle")

func face_left():
	animated_sprite.find_child("Body").flip_h = true
	animated_sprite.find_child("Hand1").z_index = -2
	animated_sprite.find_child("Hand2").z_index = 0

func face_right():
	animated_sprite.find_child("Body").flip_h = false
	animated_sprite.find_child("Hand1").z_index = 0
	animated_sprite.find_child("Hand2").z_index = -2

func _physics_process(delta):
	# Get the input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	
	# Update velocity
	var movement_scaling_factor = 1.0
	if input_direction.x != 0 and input_direction.y != 0:
		movement_scaling_factor = 0.7
		
	velocity = input_direction * movement_speed * movement_scaling_factor
	
	# Update facing direction
	
	var facing_direction = input_direction.x
	if facing_direction == -1:
		face_left()
	elif facing_direction == 1:
		face_right()
		
	# Play the correct animation
	if input_direction != Vector2(0, 0):
		play_running_animation()
	else:
		play_idle_animation()
	
	# Move and Slide function uses velocity of character body to move around the map
	move_and_slide()
