extends CharacterBody2D

const WALL_ZIndex = -14

@export var movement_speed : float = 100
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var layer_detection : Area2D = $LayerDetection
@onready var sword : Sprite2D = $Sword


@onready var hand1 : Sprite2D = sprite.find_child("Hand1")
@onready var hand2 : Sprite2D = sprite.find_child("Hand2")
@onready var body : Sprite2D = sprite.find_child("Body")

@export var safezone : bool = true

var direction : Vector2 = Vector2.ZERO
var facing_direction : int = -1 # 1 for right , -1 for left

func _ready():
	animation_tree.active = true
	# animation_tree["parameters/conditions/in_safezone"] = true
	sprite.z_index = 0

func update_animation_parameters():
	if safezone == true:	
		animation_tree["parameters/conditions/in_safezone"] = true
		animation_tree["parameters/conditions/in_dangerzone"] = false
	else:
		animation_tree["parameters/conditions/in_safezone"] = false
		animation_tree["parameters/conditions/in_dangerzone"] = true
	
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false
	
	# If adding different animations for up down left right , careful here !
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Idle_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Running/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Running_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
		#print(direction - Vector2(-facing_direction, 0))
	
func _process(delta):
	pass

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
	if input_direction.x != 0:
		facing_direction = input_direction.x
	
	# Play the correct animation
	update_animation_parameters()
	
	# Move and Slide function uses velocity of character body to move around the map
	move_and_slide()


