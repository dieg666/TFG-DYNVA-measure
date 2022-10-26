extends CanvasLayer

var velocity = 0
var size = 0
var rotationDegree = 0
var userRotationSuccess = 0
var score = 0
var iterations = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
	
func show_debug_stats():
	$HBoxContainer/Label.text = "Velocity: " + str(velocity)
	$HBoxContainer/Label2.text = "Size: " + str(size)
	$HBoxContainer/Label3.text = "Rotation: " + str(rotationDegree)
	var userRotationSuccessString = ""
	if userRotationSuccess == 1:
		userRotationSuccessString = "yes"
	elif userRotationSuccess == 0:
		userRotationSuccessString = "no"
	elif userRotationSuccess == 2:
		userRotationSuccessString = "non defined"
	$HBoxContainer/Label4.text = "Sucess: " + userRotationSuccessString
	$HBoxContainer/Label5.text = "Score: " + str(score) + "/" + str(iterations) + "("+str(100*round_to_dec(float(score)/float(iterations),4))+"%)"
