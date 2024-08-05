extends CharacterBody2D

const WALL_ZIndex = -14

@export var movement_speed : float = 100

@onready var attack_speed : float = 1.2

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var layer_detection : Area2D = $LayerDetection
@onready var attack_timer = $Weapon/AttackComponent/AttackTimer
@onready var attack_speed_timer = $Weapon/AttackComponent/AttackSpeed


@onready var hand1 : Sprite2D = sprite.find_child("Hand1")
@onready var hand2 : Sprite2D = sprite.find_child("Hand2")
@onready var body : Sprite2D = sprite.find_child("Body")
@onready var sword : Sprite2D = sprite.find_child("Sword")

@export var safezone : bool = true

var direction : Vector2 = Vector2.ZERO
var attack_direction : Vector2 = Vector2.ZERO
var facing_direction : int = -1 # 1 for right , -1 for left
var is_attacking : bool = false
var attacking_cooldown : bool = false


func _ready():
	animation_tree.active = true
	# animation_tree["parameters/conditions/in_safezone"] = true
	body.z_index = 0

func update_animation_parameters():
	
	# Attacking
	if is_attacking:
		animation_tree["parameters/conditions/is_attacking"] = true
	else:
		animation_tree["parameters/conditions/is_attacking"] = false
	
	# Safezone / Dangerzone
	if safezone == true:	
		animation_tree["parameters/conditions/in_safezone"] = true
		animation_tree["parameters/conditions/in_dangerzone"] = false
	else:
		animation_tree["parameters/conditions/in_safezone"] = false
		animation_tree["parameters/conditions/in_dangerzone"] = true
	
	# Idle / Moving
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false
	
	# Blend Positions for Animations
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Idle_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Running/blend_position"] = direction - Vector2(-facing_direction, 0)
		animation_tree["parameters/Running_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
	
	animation_tree["parameters/Attack/blend_position"] = attack_direction
	
	'''
	if attacking_animation:
		if animation_tree["parameters/Attack/blend_position"] == Vector2.ZERO:
			animation_tree["parameters/Attack/blend_position"] = attack_direction
	else:
		animation_tree["parameters/Attack/blend_position"] = Vector2.ZERO
	'''
	#print(direction - Vector2(-facing_direction, 0))

func update_facing_direction():
	if direction.x != 0:
		facing_direction = direction.x

func swing(mouse_pos : Vector2):
	if !attacking_cooldown:
		# Animation Attack Timer 
		attack_timer.one_shot = true
		attack_timer.start(0.4)
		# How often I can attack
		attack_speed_timer.one_shot = true
		attack_speed_timer.start(attack_speed)
		
		attacking_cooldown = true
		is_attacking = true
		
		attack_direction = (mouse_pos - position).normalized()
		# print(attack_direction)

func _process(delta):
	if Input.get_action_strength("attack"):
		var mouse_pos : Vector2 = get_global_mouse_position()
		swing(mouse_pos)

func _on_attack_timer_timeout():
	is_attacking = false
	
func _on_attack_speed_timeout():
	attacking_cooldown = false

func _physics_process(delta):
	# print(body.z_index)
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
	
	update_facing_direction()
	
	# Play the correct animation
	update_animation_parameters()
	
	# Move and Slide function uses velocity of character body to move around the map
	move_and_slide()




