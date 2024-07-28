extends Node2D

@onready var player = $Player

func _ready():
	player.z_index = 0
	player.y_sort_enabled = true
	player.safezone = false
