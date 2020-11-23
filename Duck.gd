extends Area2D

class_name Duck

signal score
signal death

const speed = 70

var swerve_speed = 0

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)
	else:
		self.position.y -= speed * delta
		self.position.x += swerve_speed * delta
		if self.position.y < -100:
			top_reached()
		if $SverveTimer.is_stopped():
			$SverveTimer.wait_time = rand_range(0.1, 1.0)
			$SverveTimer.start()
			
		
		
func top_reached():
	var score = preload("res://ScorePoint.tscn").instance()
	get_parent().add_child(score)
	score.position = self.position + Vector2(0, 100)
	emit_signal("score")
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
	emit_signal("death")
	queue_free()

func _on_SverveTimer_timeout():
	random_swerve()


###########################
# Drag and Drop ###########
###########################

signal dragsignal

func _ready():
	connect("dragsignal",self,"_set_drag_pc")

var dragging = false

func _set_drag_pc():
	dragging=!dragging

func _on_Duck_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
