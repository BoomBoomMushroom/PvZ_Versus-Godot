extends Area2D

@onready var grid_manager = %GridManager

func _on_body_entered(body):
	grid_manager.hoverTile(get_node("."), body)

func _on_body_exited(body):
	grid_manager.unhoverTile(get_node("."), body)
