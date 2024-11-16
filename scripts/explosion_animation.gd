extends Node2D

var scaleToSet = 1

func _ready():
	$AnimatedSprite2D.scale = Vector2(scaleToSet, scaleToSet)

# Kill the animation as soon as we are done
func _on_animated_sprite_2d_animation_finished():
	queue_free()
