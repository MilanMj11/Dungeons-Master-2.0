extends Node2D

@onready var player = $Player
@onready var cutscene_camera = $CutsceneCamera
@onready var animation_player = $AnimationPlayer


func _ready():
	# Precaution intializers
	player.z_index = 0
	
	# Lobby specific information
	player.safezone = true
	player.y_sort_enabled = true

func _on_dungeon_entrance_body_entered(body):
	# When the player enters the Dungeon Entrance Zone ->
	# print("ok")
	
	# Show the cutscene of the character going through the "Portal"
	cutscene_camera.make_current()
	animation_player.play("EnteringDungeons")
	await animation_player.animation_finished
	
	# Change the scene to the Current Dungeon
	get_tree().change_scene_to_file("res://scenes/desert_dungeon_1.tscn")
	
