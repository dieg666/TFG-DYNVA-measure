extends Control

signal save_is_done

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	if $VBoxContainer/LineEdit.text == '':
		$VBoxContainer/Label2.text = 'Name can\'t be empty'
	elif $VBoxContainer/LineEdit.text[0] == ' ':
		$VBoxContainer/Label2.text = 'Name can\'t be start with whitespace'
	else:
		emit_signal("save_is_done")
	pass # Replace with function body.
