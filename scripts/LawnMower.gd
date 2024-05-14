extends Area2D

var speed = 1
var triggered = false

func _on_area_2d_body_entered(body):
	triggered = true
	print(body.has_meta("zombieLoad"))

func _ready():
	triggered = false


func _process(delta):
	if triggered == false: return
	
