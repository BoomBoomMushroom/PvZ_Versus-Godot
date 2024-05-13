extends CharacterBody2D


const SPEED = 50.0
const doesDamage = true

func _physics_process(delta):
	velocity.x = SPEED

	move_and_slide()
