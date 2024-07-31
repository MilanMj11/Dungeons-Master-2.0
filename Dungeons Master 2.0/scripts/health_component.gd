extends Node2D
class_name HealthComponent

@export var MAX_HEALTH = 100
var health : float

func _ready():
	health = MAX_HEALTH

func die():
	get_parent().queue_free()

func take_damage(damage : float):
	health -= damage
	if health <= 0:
		die()
