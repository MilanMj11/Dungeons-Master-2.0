extends CharacterBody2D

@export var movement_speed = 50

@onready var attack_speed : float = 0.8

@onready var player : CharacterBody2D = get_parent().get_node("Player")
@onready var tilemap = get_parent().get_node("TileMap")

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $AttackComponent/AttackTimer

@onready var sprite = $Sprite2D


@onready var Hand1 : Sprite2D = sprite.find_child("Hand1")
@onready var Hand2 : Sprite2D = sprite.find_child("Hand2")
@onready var Body : Sprite2D = sprite.find_child("Body")
@onready var Sword : Sprite2D = sprite.find_child("Sword")

@onready var raycast = $Vision
@onready var random_movement_timer = $RandomMovementTimer


var facing_direction : int = -1 # 1 for right , -1 for left
var player_position : Vector2
var direction : Vector2
var see_player : bool = false
var player_in_sight_area : bool = false
var is_attacking : bool = false

func raycast_vision_initializer():
	raycast.enabled = true
	raycast.exclude_parent = true
	raycast.collision_mask = 1
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true

func _ready():
	animation_tree.active = true
	Body.z_index = 0
	raycast_vision_initializer()

func update_animation_parameters():

	# Moving / Idle / Attacking
	if is_attacking:
		animation_tree["parameters/conditions/is_attacking"] = true
	else:
		animation_tree["parameters/conditions/is_attacking"] = false
		
	
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false

	# Direction of the played animation
	#if direction != Vector2.ZERO:
	animation_tree["parameters/Idle/blend_position"] = direction - Vector2(-facing_direction, 0)
	#animation_tree["parameters/Idle_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
	animation_tree["parameters/Running/blend_position"] = direction - Vector2(-facing_direction, 0)
	#animation_tree["parameters/Running_with_weapon/blend_position"] = direction - Vector2(-facing_direction, 0)
	animation_tree["parameters/Attack/blend_position"] = direction - Vector2(-facing_direction, 0)
	#print(direction - Vector2(-facing_direction, 0))

func check_to_see_player():

	raycast.target_position = player_position - ( position - Vector2(4, 15))
	var collision = raycast.is_colliding()
	
	if collision:
		# There is a collision between the mummy and the player
		see_player = false
	else:
		# There is no collision between the mummy and the player
		see_player = true


func _on_sight_body_entered(body):
	if body == player:
		player_in_sight_area = true

func _on_sight_body_exited(body):
	if body == player:
		player_in_sight_area = false

func _process(delta):
	pass

func update_facing_direction():
	if direction.x != 0:
		facing_direction = direction.x

func initiate_attack():
	is_attacking = true
	attack_timer.one_shot = true
	attack_timer.start(attack_speed)


func _physics_process(delta):

	if attack_timer.time_left == 0:
		is_attacking = false
	
	player_position = player.position
	check_to_see_player()

	# Update the facing direction
	update_facing_direction()

	# Update animation parameters
	update_animation_parameters()
	
	# Calculate Velocity
	if !is_attacking:
		if player_in_sight_area and see_player:
			direction = (player_position - position).normalized()
			velocity = direction * movement_speed
			animation_tree.advance(delta)
			
		else:
			if random_movement_timer.time_left == 0:
				random_movement_timer.start(2.5)
				
			velocity = direction * movement_speed / 2
			animation_tree.advance(delta * 0.6)
	else:
		velocity = Vector2.ZERO
		animation_tree.advance(delta)
		
	# Move / Initiate Attack
	if position.distance_to(player_position) > 20:
		move_and_slide()
	else:
		if !is_attacking:
			initiate_attack()

	
	
func _on_random_movement_timer_timeout():
	# Generate random direction
	var rng_dir = RandomNumberGenerator.new()
	var random_direction_x = rng_dir.randf_range(-1.0, 1.0)
	var random_direction_y = rng_dir.randf_range(-1.0, 1.0)
	direction = Vector2(random_direction_x, random_direction_y).normalized()
	
	# Generate possibility of staying AFK instead of moving
	var rng_afk = RandomNumberGenerator.new()
	var stays_afk = rng_afk.randi_range(1,4)
	if stays_afk == 1:
		direction = Vector2.ZERO
	
