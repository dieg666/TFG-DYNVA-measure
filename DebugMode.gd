extends CanvasLayer

var velocity = 0
var size = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_debug_stats():
	show()
	$HBoxContainer/Label.text="Velocity: " + str(velocity)
	$HBoxContainer/Label2.text="Size: " + str(size)
	pass # Replace with function body.
