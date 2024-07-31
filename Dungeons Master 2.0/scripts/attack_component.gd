extends Node2D
class_name AttackComponent

@export var ATTACK_DAMAGE = 20
var damage : float

func _ready():
	damage = ATTACK_DAMAGE

