extends CharacterBody2D

const WALL_ZIndex = -14

@export var movement_speed : float = 100
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var layer_detection = $LayerDetection

var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true
	sprite.z_index = 0
	# animation_player.play("Idle")
	face_right()

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false
	
	# If adding different animations for up down left right , careful here !
	# animation_tree["parameters/Idle/blend_position"] = direction
	# animation_tree["parameters/Running/blend_position"] = direction
	
func _process(delta):
	pass

func face_left():
	sprite.find_child("Body").flip_h = true
	sprite.find_child("Hand1").z_index = sprite.find_child("Body").z_index - 2
	sprite.find_child("Hand2").z_index = sprite.find_child("Body").z_index

func face_right():
	sprite.find_child("Body").flip_h = false
	sprite.find_child("Hand1").z_index = sprite.find_child("Body").z_index
	sprite.find_child("Hand2").z_index = sprite.find_child("Body").z_index - 2

func _physics_process(delta):
	# Get the input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	direction = input_direction
	
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
	update_animation_parameters()
	
	# Move and Slide function uses velocity of character body to move around the map
	move_and_slide()


