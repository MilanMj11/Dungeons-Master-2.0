extends ProgressBar
class_name HealthBar

@export var HEALTH_COMPONENT : HealthComponent

func _ready():
	# self.HEALTH_COMPONENT._ready()
	self.show_percentage = false

func _process(delta):
	self.max_value = HEALTH_COMPONENT.MAX_HEALTH
	self.value = HEALTH_COMPONENT.health
