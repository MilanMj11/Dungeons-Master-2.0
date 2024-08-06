extends Node2D

@onready var player = $Player

func _ready():
	player.z_index = 0
	player.y_sort_enabled = true
	player.safezone = false

func _process(delta):
	if !player:
		get_tree().change_scene_to_file("res://scenes/desert_dungeon_1.tscn")
