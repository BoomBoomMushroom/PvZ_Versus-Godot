extends CharacterBody2D

var speed = 300.0
var health = 100.0
var directionMult = -1

func _ready():
	speed = get_meta("speed")
	health = get_meta("health")
	directionMult = get_meta("directionMult")

func _process(delta):
	if health <= 0: queue_free()

func _physics_process(delta):
	velocity.x = speed * directionMult

	move_and_slide()


func _on_hit_collide_body_entered(body):
	health -= body.get_meta("damage")
	body.queue_free()
