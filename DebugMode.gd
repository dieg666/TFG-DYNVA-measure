extends CanvasLayer

var velocity = 0
var size = 0
var rotationDegree = 0
var userRotationSuccess = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_debug_stats():
	show()
	$HBoxContainer/Label.text = "Velocity: " + str(velocity)
	$HBoxContainer/Label2.text = "Size: " + str(size)
	$HBoxContainer/Label3.text = "Rotation: " + str(rotationDegree)
	var userRotationSuccessString = ""
	if userRotationSuccess == 1:
		userRotationSuccessString = "yes"
	if userRotationSuccess == 0:
		userRotationSuccessString = "no"
	if userRotationSuccess == 2:
		userRotationSuccessString = "non defined"
	$HBoxContainer/Label4.text = "Sucess: " + userRotationSuccessString
