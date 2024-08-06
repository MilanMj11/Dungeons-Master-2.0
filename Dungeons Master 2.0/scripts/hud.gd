extends CanvasLayer

@export var HEALTH_COMPONENT : HealthComponent
@onready var health_bar = $Control/HealthBar

func _ready():
	health_bar.HEALTH_COMPONENT = HEALTH_COMPONENT

func _process(delta):
	pass
	# print(health_bar.HEALTH_COMPONENT.health)
	
