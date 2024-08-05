extends Node2D

@onready var attack_component = $AttackComponent
@onready var player = $".."

var damage_cooldown : bool = false  # Acts like a switch to prevent multiple hits in one attack
var enemiesHit : Array[HitboxComponent] = []

func _physics_process(delta):
	if !player.is_attacking:
		enemiesHit = []

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		if player.is_attacking:
			if !enemiesHit.has(area):
				enemiesHit.append(area)
				var hitbox : HitboxComponent = area
				hitbox.get_damage(attack_component)
				
		
