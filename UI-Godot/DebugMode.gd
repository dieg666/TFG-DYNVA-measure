extends CanvasLayer

var velocity = 0
var size = 0
var rotationDegree = 0
var userRotationSuccess = 0
var score = 0
var iterations = 1
var unix_time: float
var travelledPixels = 0 
var sizeDot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sizeDot = 0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)


	
func show_debug_stats():
	$HBoxContainer/Label.text = "Velocity: " + str(velocity) + "px/s" + ", " + str(velocity*sizeDot/1000) + "m/s"
	$HBoxContainer/Label2.text = "Size Opto" + str(size)+ " px" + ", " + str(size.x*sizeDot) + "mm"
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
	
	$HBoxContainer/Label6.text = "Time: " + str(Time.get_unix_time_from_system() - unix_time)
	$HBoxContainer/Label7.text = "Travelled Pixels: " + str(travelledPixels)
	

func _on_Octo_start_timer():
	unix_time=  Time.get_unix_time_from_system()
	
func elapsed_time():
	return Time.get_unix_time_from_system() - unix_time
