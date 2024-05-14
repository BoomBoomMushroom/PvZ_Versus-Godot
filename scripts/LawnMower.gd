extends CharacterBody2D

var speed = 40
var triggered = false
var maxX = 0

func _on_area_2d_body_entered(body):
	if body.has_meta("zombieLoad"):
		triggered = true
		body.health = 0

func _ready():
	triggered = false

func _process(delta):
	if position.x >= maxX: queue_free()

func _physics_process(delta):
	if triggered == false: return
	velocity.x = speed
	
	move_and_slide()
