extends ProgressBar
class_name HealthBar

@export var HEALTH_COMPONENT : HealthComponent

func _ready():
	self.show_percentage = false

func update():
	self.max_value = HEALTH_COMPONENT.MAX_HEALTH
	self.value = HEALTH_COMPONENT.health
