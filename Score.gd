extends CanvasLayer

var score = 0
var iterations = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Main_show_score():
	$VBoxContainer/ScoreLabel.text = "Score: "+str(score)+ " out of "+ str(iterations)+" attempts."
	pass # Replace with function body.
