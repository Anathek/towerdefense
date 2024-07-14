extends StaticBody3D

var bullet : PackedScene = preload("res://Scenes/bullet.tscn")
var bullet_damage : int = 5
var current_targets : Array = []
var curr : CharacterBody3D
var can_shoot : bool = true

func _process(delta):
	if is_instance_valid(curr):
		look_at(curr.global_position)
		if can_shoot:
			shoot()
			can_shoot = false
			$ShootingCooldown.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func shoot() -> void:
	var temp_bullet1 : CharacterBody3D = bullet.instantiate()
	temp_bullet1.target = curr
	temp_bullet1.bullet_damage = bullet_damage
	get_node("BulletContainer").add_child(temp_bullet1)
	temp_bullet1.global_position = $WeaponCannon/Marker.global_position
	
	var temp_bullet2 : CharacterBody3D = bullet.instantiate()
	temp_bullet2.target = curr
	temp_bullet2.bullet_damage = bullet_damage
	get_node("BulletContainer").add_child(temp_bullet2)
	temp_bullet2.global_position = $WeaponCannon/Marker2.global_position

func choose_target(_current_targets : Array) -> void:
	var temp_array : Array = _current_targets
	var current_target : CharacterBody3D = null
	for i in temp_array:
		if current_target == null:
			current_target = i
		else:
			if i.get_parent().get_progress() > current_target.get_parent().get_progress():
				current_target = i
				
	curr = current_target

func _on_mob_detector_body_entered(body):
	if body.is_in_group("Enemy"):
		current_targets.append(body)
		choose_target(current_targets)


func _on_mob_detector_body_exited(body):
	if body.is_in_group("Enemy"):
		current_targets.erase(body)
		choose_target(current_targets)


func _on_shooting_cooldown_timeout():
	can_shoot = true
