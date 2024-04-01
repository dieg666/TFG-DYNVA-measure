extends VBoxContainer
signal delete
signal add
var button
var num
var rightClick
var text = ''
# Declare member variables here. Examples:
# var a = 2
func set_text(t):
	$Button.text = str(t)
func set_sufix(t):
	$SpinBox.suffix = str(t)
# Called when the node enters the scene tree for the first time.
func _ready():
	rightClick= 0
	button =  Button.new()
	num = SpinBox.new()
	
	pass # Replace with function body.
func set_value(v):
	$SpinBox.value = v
func value():
	return $SpinBox.value
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func is_Pressed():
	return rightClick
func reset_click():
	rightClick = 0
func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_RIGHT:
				rightClick = 1
				emit_signal("delete")
			BUTTON_LEFT:
				rightClick = 2
				emit_signal("add")
	pass # Replace with function body.
