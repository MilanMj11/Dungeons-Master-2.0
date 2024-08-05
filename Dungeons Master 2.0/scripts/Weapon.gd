extends Node2D

@onready var attack_component = $AttackComponent

func _on_hitbox_area_entered(area):
	# print(area.name)
	if area is HitboxComponent:
		# The Weapon will not check collisions with the player , only the enemies
		var hitbox : HitboxComponent = area
		
		hitbox.get_damage(attack_component)
		
