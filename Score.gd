extends CanvasLayer
signal home
var parsedValues = 0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = $VBoxContainer/ScoreLabel.rect_size
	var pos = -rect/2
	$VBoxContainer/ScoreLabel.rect_position = pos # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Main_show_score():
	$VBoxContainer/ScoreLabel.text = "RESULTS: \n"
	for i in range(0,parsedValues.size()):
		if parsedValues[i][0] !=-1 and parsedValues[i][0]!=-1  and parsedValues[i][0]!=-1:
			$VBoxContainer/ScoreLabel.text += "TEST:"+str(i+1)+". LogMar = " + str(parsedValues[i][0])+", Decimal = " + str(parsedValues[i][1])+". Speed = " + str(parsedValues[i][2])+"º/s\n"
		else:
			$VBoxContainer/ScoreLabel.text += "TEST:"+str(i+1)+". No results. Error threshold has been exceeded.\n"
	var rect = $VBoxContainer/ScoreLabel.rect_size
	var pos = -rect/2
	$VBoxContainer/ScoreLabel.rect_position = pos # Replace with function body.


func _on_Button2_pressed():
	emit_signal("home")
	pass # Replace with function body.


func _on_Button_pressed():
	var username = OS.get_environment("USERNAME")
	var time = OS.get_datetime()
	var path = "C:/Users/"+username+"/Documents/test_"+str(time['day'])+"-"+str(time['month'])+"-"+str(time['year'])+".csv"
	$FileDialog.access = FileDialog.ACCESS_FILESYSTEM
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$FileDialog.set_current_path(path)
	$FileDialog.set_filters(PoolStringArray(["*.csv ; csv file"]))
	$FileDialog.popup_centered_minsize(Vector2(500,500))
	
	pass # Replace with function body.


func _on_FileDialog_confirmed():
	print($FileDialog.current_dir)
	print($FileDialog.current_path)
	print($FileDialog.current_file)
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var csv = "test_number, logMAR value, decimal value, speed\n"
	for i in range(0,parsedValues.size()):
		csv += str(i+1)+"," + str(parsedValues[i][0])+"," + str(parsedValues[i][1])+"," + str(parsedValues[i][2])+"\n"
	print("csv")
	print(csv)
	var save_game = File.new()
	
	save_game.open(path, File.WRITE)
	save_game.store_line(csv)
	save_game.close()
	print("File Selected: ", path)
