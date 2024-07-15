extends CharacterBody3D

@export var speed : int = 2
@export var health : int = 15

@onready var Path : PathFollow3D = get_parent()

func  _ready():
	$HealthBar3D.set_up(health)
	
func _physics_process(delta):
	Path.set_progress(Path.get_progress() + speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Global.health -= 20		
		Global.enemies_alive -= 1
		Path.queue_free()
		
func take_damage(damage):
	health -= damage
	$HealthBar3D.update(health)
	
	if health <= 0:
		Global.money += 50
		death()
		
func death() -> void:
	Global.enemies_alive -= 1
	Path.queue_free()
