extends Area2D
class_name HitboxComponent

@export var HEALTH_COMPONENT : HealthComponent

func get_damage(attack: AttackComponent):
	if HEALTH_COMPONENT:
		HEALTH_COMPONENT.take_damage(attack)
