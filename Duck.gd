extends Area2D

class_name Duck

const speed = 70

var swerve_speed = 0

func _process(delta):
	self.position.y -= speed * delta
	self.position.x += swerve_speed * delta
	if self.position.y < -100:
		destroy()
	if $SverveTimer.is_stopped():
		$SverveTimer.wait_time = rand_range(0.1, 1.0)
		$SverveTimer.start()
		
func destroy():
	queue_free()

func random_swerve():
	swerve_speed = rand_range(-30, 30)
	if self.position.x + swerve_speed <= 0:
		swerve_speed = -swerve_speed
	if self.position.x + swerve_speed >= get_viewport().size.x:
		swerve_speed = - swerve_speed

func take_damage():
	var prefab = preload("res://DeadDuck.tscn")
	var deadduck = prefab.instance()
	get_parent().add_child(deadduck)
	deadduck.position = self.global_position
	queue_free()

func _on_SverveTimer_timeout():
	random_swerve()
