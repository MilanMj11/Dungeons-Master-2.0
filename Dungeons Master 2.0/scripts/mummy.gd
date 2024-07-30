extends CharacterBody2D

@export var movement_speed = 50

@onready var player : CharacterBody2D = get_parent().get_node("Player")
@onready var tilemap = get_parent().get_node("TileMap")

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite = $Sprite2D

@onready var hand1 : Sprite2D = sprite.find_child("Hand1")
@onready var hand2 : Sprite2D = sprite.find_child("Hand2")
@onready var body : Sprite2D = sprite.find_child("Body")
@onready var sword : Sprite2D = sprite.find_child("Sword")

@onready var raycast = $Vision
@onready var random_movement_timer = $RandomMovementTimer


var facing_direction : int = -1 # 1 for right , -1 for left
var player_position : Vector2
var direction : Vector2
var see_player : bool = false
var player_in_sight_area : bool = false

func raycast_vision_initializer():
	raycast.enabled = true
	raycast.exclude_parent = true
	raycast.collision_mask = 1
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true

func _ready():
	animation_tree.active = true
	body.z_index = 0
	raycast_vision_initializer()

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false

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

func _physics_process(delta):

	player_position = player.position
	check_to_see_player()
		
	# Calculate Velocity
	if player_in_sight_area and see_player:
		direction = (player_position - position).normalized()
		velocity = direction * movement_speed
		
	else:
		# print(random_movement_timer.time_left)
		
		if random_movement_timer.time_left == 0:
			random_movement_timer.start(2.5)
			
		velocity = direction * movement_speed / 2
	
	if position.distance_to(player_position) > 3:
		move_and_slide()
		# sprite2d.look_at(player_position) -> interesting function


func _on_random_movement_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var random_direction_x = rng.randf_range(-1.0, 1.0)
	var random_direction_y = rng.randf_range(-1.0, 1.0)
	direction = Vector2(random_direction_x, random_direction_y).normalized()
	
